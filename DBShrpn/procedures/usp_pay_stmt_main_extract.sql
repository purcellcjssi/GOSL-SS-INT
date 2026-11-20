USE DBShrpn
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID(N'dbo.usp_pay_stmt_main_extract', N'P') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.usp_pay_stmt_main_extract
    IF OBJECT_ID(N'dbo.usp_pay_stmt_main_extract') IS NOT NULL
        PRINT N'<<< FAILED DROPPING PROCEDURE dbo.usp_pay_stmt_main_extract >>>'
    ELSE
        PRINT N'<<< DROPPED PROCEDURE dbo.usp_pay_stmt_main_extract >>>'
END
GO

/*************************************************************************************

    SP Name:
        usp_pay_stmt_main_extract

    Description:
        SmartStream to HCM Cloud Suite Pay Check Extract Interface



    Parameters:
		@p_payroll_run_ctrl_id	= Payroll Run Control ID
		@p_pmt_meth_id			= Payment Method ID
		@p_emp_id				= Employee ID - Tilde (~) delimited string - for debugging purposes only, will typically be null to pull all employees

    Tables:
        DBShrpy.dbo.emp_pmt
        DBShrpy.dbo.emp_pmt_disbursal_detail
        DBShrpy.dbo.emp_pmt_pay_element_detail
        DBShrpy.dbo.emp_pay_element_accum
        DBShrpy.dbo.offline_payroll_err_message

        DBShrpn.dbo.ghr_pay_check
        DBShrpn.dbo.ghr_pay_check_earning
        DBShrpn.dbo.ghr_pay_check_deduction


    Example:
         EXEC DBShrpn.dbo.usp_pay_stmt_main_extract
            , @p_payroll_run_ctrl_id = 'M6Y2026T2'
            , @p_pmt_meth_id         = 'DDPST'
            , @p_emp_id              = '17201~17202~17203'


   Revision history:
   version  date        developer   SCR         description
   -------  ----------  ---------   -----       ------------------------------------
   1.0.00   05/05/2026  CJP                     - Created procedure

************************************************************************************/
CREATE procedure dbo.usp_pay_stmt_main_extract
    (
        @p_payroll_run_ctrl_id   char(10)    = NULL
    ,   @p_pmt_meth_id           char(05)    = NULL
    ,   @p_emp_id                varchar(8000)    = NULL
    )
AS

BEGIN

    SET NOCOUNT ON

    DECLARE @v_step_position            varchar(255)        = 'Begin Procedure'

    DECLARE @v_END_OF_TIME_DATE         datetime            = '29991231'
    DECLARE @V_ENGLISH_LANG_CODE        char(5)             = 'EN' -- English

    DECLARE @ErrorNumber                varchar(10)
    DECLARE @ErrorMessage               nvarchar(4000)
    DECLARE @ErrorSeverity              int
    DECLARE @ErrorState                 int
    DECLARE @v_ret_val                  int                 = 0

    DECLARE @v_msg                      varchar(4000)
    DECLARE @v_rowcount                 int

    DECLARE @v_userid			        varchar(30)
    DECLARE @v_PSC_BATCHNAME            char(08)            = 'GHR'
    DECLARE @v_PSC_QUALIFIER            char(30)            = 'PAYSLIP_INTERFACE'


    BEGIN TRY


        -- Get the user id executing the job
        SET @v_userid = SYSTEM_USER



        ---------------------------------------------------------------------------
        -- Lookup Run Control/Payment Mehod
        ---------------------------------------------------------------------------
        SET @v_step_position = 'Validate Payroll Run Control ID'

        IF (@p_payroll_run_ctrl_id IS NULL)
            BEGIN
                SELECT @p_payroll_run_ctrl_id = REVERSE(PARSENAME(REPLACE(REVERSE(pl1.psc_pgm_parms), ' ', '.'), 1))
                    , @p_pmt_meth_id         = REVERSE(PARSENAME(REPLACE(REVERSE(pl1.psc_pgm_parms), ' ', '.'), 2))
                FROM DBSpscb.dbo.psc_log pl1
                WHERE (pl1.psc_batchname = 'BATDISB')
				  AND (pl1.psc_pgm_name  = 'hpycdisb')
                  AND (psc_unique_id = (
                                        SELECT MAX(pl2.psc_unique_id)
                                        FROM DBSpscb.dbo.psc_log pl2
                                        WHERE (pl2.psc_batchname = pl1.psc_batchname)
										  AND (pl2.psc_pgm_name = pl1.psc_pgm_name)
                                            AND (pl2.psc_curtime = (
                                                                    SELECT MAX(pl3.psc_curtime)
                                                                    FROM DBSpscb.dbo.psc_log pl3
                                                                    WHERE (pl3.psc_batchname = pl1.psc_batchname)
																	  AND (pl3.psc_pgm_name = pl1.psc_pgm_name)
                                                                    ))
                                        ))

                -- Validate lookup of run control parameter


                IF (@p_payroll_run_ctrl_id IS NULL)
                    BEGIN
                        SET @v_msg = 'Invalid payroll run control id (' + @p_payroll_run_ctrl_id + '). Was not able to determine the most recent disbursed run control in table DBSpscb.dbo.psc_log.'
                        RAISERROR(@v_msg, 16, 1)
                    END


            END
        ELSE
            BEGIN
                -- Validate run control parameter
                IF NOT EXISTS (
                            SELECT 1
                            FROM DBShrpy..emp_pmt pmt
                            JOIN DBShrpn..payroll_run_ctrl ctrl ON
                                    (pmt.procsd_by_payroll_run_ctrl_id = ctrl.payroll_run_ctrl_id)
                                WHERE (pmt.procsd_by_payroll_run_ctrl_id = @p_payroll_run_ctrl_id)
                                AND (pmt.emp_pmt_status_code           = '05')        -- Completely disbursed
                                AND (pmt.pmt_type_code                 = '01')        -- Only Offline Payments - Exclude all else
                                AND (ctrl.payroll_run_status_code      = '02')	    -- run successfully
                            )
                BEGIN
                    SET @v_msg = 'Invalid payroll run control id (' + @p_payroll_run_ctrl_id + '). Run control was not found in table DBShrpn..payroll_run_ctrl.'
                    RAISERROR(@v_msg, 16, 1)
                END
            END




        ---------------------------------------------------------------------------
        -- Delete previous generated records
        ---------------------------------------------------------------------------
        DELETE FROM dbo.ghr_pay_check


        ---------------------------------------------------------------------------
        -- Header ViewEmployeePayCheck
        ---------------------------------------------------------------------------
        SET @v_step_position = 'Insert into DBShrpn.dbo.ghr_pay_check'

        INSERT INTO dbo.ghr_pay_check
        SELECT pmt.emp_id
            , pmt.payroll_run_type_id
            , pmt.pay_pd_id
            , pmt.pmt_seq_nbr
            , pmt.seq_ctrl_yr
            , pmt.procsd_by_payroll_run_ctrl_id

            , 'GOSL' AS hr_org                         -- HROrganization
            , pmt.emp_id                               -- Employee
            , pmt.pay_pd_begin_date                    -- EffectiveDate
            , MAX(dsb.check_or_deposit_advice_nbr) AS CheckID          -- CheckID
            , MAX(dsb.check_or_deposit_advice_nbr) AS CheckNumber          -- CheckNumber
            , pmt.pmt_net_pay_amt                      -- NetPayAmount
            , pmt.ytd_net_pay_amt                      -- YearToDateNetPay
            , pmt.check_date                          -- CheckDate
            , pmt.pay_pd_begin_date                    -- PayPeriodDateRange.BeginDate
            , pmt.pay_pd_end_date                      -- PayPeriodDateRange.EndDate
            , pmt.pmt_net_pay_amt                      -- CheckNetAmount
            , pmt.pmt_tot_gross_pay_amt                    -- GrossPayAmount
            , pmt.pmt_tot_gross_pay_amt                    -- YearToDateGrossPay
            , pmt.pmt_tot_deductions_wh_amt - ISNULL(ele.tot_current_monetary_amt, 0.00) AS TotalCheckDeductions              -- TotalCheckDeductions
            , pmt.ytd_tot_deductions_wh_amt  - ISNULL(ele.ytd_monetary_amt, 0.00) AS TotalYearToDateDeductions             -- TotalYearToDateDeductions

        FROM DBShrpy.dbo.emp_pmt pmt WITH (NOLOCK)
        JOIN DBShrpy.dbo.emp_pmt_disbursal_detail dsb WITH (NOLOCK) ON
            (pmt.emp_id              = dsb.emp_id) AND
            (pmt.payroll_run_type_id = dsb.payroll_run_type_id) AND
            (pmt.pay_pd_id           = dsb.pay_pd_id) AND
            (pmt.pmt_seq_nbr         = dsb.pmt_seq_nbr)
        -- Pay Element DPAYE Calculates Taxes
        LEFT JOIN DBShrpy.dbo.emp_pmt_pay_element_detail ele ON
            (pmt.emp_id              = ele.emp_id) AND
            (pmt.payroll_run_type_id = ele.payroll_run_type_id) AND
            (pmt.pay_pd_id           = ele.pay_pd_id) AND
            (pmt.pmt_seq_nbr         = ele.pmt_seq_nbr) AND
            (ele.pay_element_id      = 'DPAYE')

        WHERE (1=1)
        AND (pmt.emp_pmt_status_code        = '05')       -- Completely disbursed
        AND (pmt.pmt_type_code              = '01')       -- Only Offline Payments - Exclude all else
        AND (dsb.doc_disbursal_status_code <> '06')       -- Exclude voids due to overflows on earnings statement

        AND (
                (@p_payroll_run_ctrl_id IS NULL) OR
                (
                (@p_payroll_run_ctrl_id IS NOT NULL) AND
                (pmt.procsd_by_payroll_run_ctrl_id = @p_payroll_run_ctrl_id)
                )
            )

        AND (
                (@p_pmt_meth_id IS NULL) OR
                (
                (@p_pmt_meth_id IS NOT NULL) AND
                (dsb.pmt_meth_id = @p_pmt_meth_id)
                )
            )

        AND (  -- associate id
            (@p_emp_id IS NULL) OR
            (
                (@p_emp_id IS NOT NULL) AND
                (pmt.emp_id IN (SELECT val FROM dbo.ufn_text_splitter(@p_emp_id, '~')))
            )
            )

        GROUP BY pmt.emp_id
            , pmt.payroll_run_type_id
            , pmt.pay_pd_id
            , pmt.pmt_seq_nbr
            , pmt.seq_ctrl_yr
            , pmt.procsd_by_payroll_run_ctrl_id
            , pmt.check_date                           -- CheckDate
            , pmt.pay_pd_begin_date                    -- PayPeriodDateRange.BeginDate
            , pmt.pay_pd_end_date                      -- PayPeriodDateRange.EndDate
            , pmt.pmt_net_pay_amt                      -- NetPayAmount
            , pmt.ytd_net_pay_amt                      -- YearToDateNetPay
            , pmt.pmt_tot_gross_pay_amt                -- GrossPayAmount
            , pmt.ytd_tot_gross_pay_amt                -- YearToDateGrossPay
            , pmt.pmt_tot_deductions_wh_amt
            , pmt.ytd_tot_deductions_wh_amt
            , ele.tot_current_monetary_amt
            , ele.ytd_monetary_amt

        SET @v_rowcount = @@ROWCOUNT


        IF (@v_rowcount = 0)
            BEGIN
                RAISERROR('No rows were inserted into table dbo.ghr_pay_check_earning.', 16, 1);
            END
        ELSE
            BEGIN
                SET @v_msg = 'Header rows inserted into table dbo.ghr_pay_check: (' + CONVERT(varchar(18), @v_rowcount) + ') '
                EXEC DBSpscb.dbo.psp_ins_psc_putmsg_2
                      @userid   = @v_userid
                    , @batch    = @v_PSC_BATCHNAME
                    , @qual     = @v_PSC_QUALIFIER
                    , @msgno    = 'U00011'  -- Blank message id text
                    , @severity = 0
                    , @text     = @v_msg
                    , @text_2   = ''
                    , @text_3   = ''
            END


        ---------------------------------------------------------------------------
        -- ViewEmployeePayCheckEarning
        ---------------------------------------------------------------------------
        SET @v_step_position = 'Insert into DBShrpn.dbo.ghr_pay_check_earning'

        INSERT INTO dbo.ghr_pay_check_earning
        SELECT chk.emp_id
            , chk.payroll_run_type_id
            , chk.pay_pd_id
            , chk.pmt_seq_nbr
            , ele.pay_element_id

            , chk.HROrganization                   -- HROrganization
            , chk.emp_id                           -- Employee
            , chk.EffectiveDate                    -- Effective_date
            , chk.CheckDate                        -- CheckDate
            , chk.CheckID                          -- CheckID
            , row_number() OVER(PARTITION BY chk.emp_id, chk.pay_pd_id ORDER BY chk.CheckID, chk.PayPeriodEndDate, ele.pay_element_id) AS row_nbr -- CheckEarning (counter)
            , descp.short_descp                    -- Description
            , ele.tot_current_monetary_amt         -- EarningsAmount
            , chk.PayPeriodBeginDate               -- BeginDate
            , chk.PayPeriodEndDate                 -- EndDate
            , ele.ytd_monetary_amt                 -- YearToDateEarningsAmount

        FROM dbo.ghr_pay_check chk
        JOIN DBShrpy.dbo.emp_pmt_pay_element_detail ele on
            (chk.emp_id              = ele.emp_id) AND
            (chk.payroll_run_type_id = ele.payroll_run_type_id) AND
            (chk.pay_pd_id           = ele.pay_pd_id) AND
            (chk.pmt_seq_nbr         = ele.pmt_seq_nbr)

    JOIN DBShrpn.dbo.pay_element pe ON
            (ele.pay_element_id              = pe.pay_element_id)
    JOIN DBShrpn.dbo.pay_element_descp descp ON
            (pe.pay_element_id   = descp.pay_element_id) AND
            (pe.eff_date         = descp.eff_date)

        WHERE (ele.pmt_detail_type_code  = '1')      -- Pay Element
        AND (ele.pay_element_type_code = '1')     -- Earning
        AND (pe.next_eff_date          = @v_END_OF_TIME_DATE)
        AND (descp.language_code       = @V_ENGLISH_LANG_CODE)


        SET @v_rowcount = @@ROWCOUNT

        SET @v_msg = 'Earnings Rows inserted into table dbo.ghr_pay_check_earning: (' + CONVERT(varchar(18), @v_rowcount) + ') '
        EXEC DBSpscb.dbo.psp_ins_psc_putmsg_2
              @userid   = @v_userid
            , @batch    = @v_PSC_BATCHNAME
            , @qual     = @v_PSC_QUALIFIER
            , @msgno    = 'U00011'  -- Blank message id text
            , @severity = 0
            , @text     = @v_msg
            , @text_2   = ''
            , @text_3   = ''





        ---------------------------------------------------------------------------
        -- ViewEmployeePayCheckDeduction
        ---------------------------------------------------------------------------
        SET @v_step_position = 'Insert into DBShrpn.dbo.ghr_pay_check_deduction'

        ;WITH seq_cte (pyrl_processing_seq_entry_nbr, pay_element_id)
        AS
        (
            SELECT ppsq.pyrl_processing_seq_entry_nbr
                , CASE WHEN pepge.pay_element_id IS NULL THEN ppsq.entry_id ELSE pepge.pay_element_id END AS pay_element_id
            FROM DBShrpn.dbo.payroll_processing_seq_entry ppsq
            LEFT JOIN DBShrpn.dbo.pay_elem_processing_grp_entry pepge ON
                (ppsq.entry_id = pepge.pay_element_processing_grp_id)
            WHERE (ppsq.payroll_processing_seq_id = 'GOSLPPS')
            AND (ppsq.entry_type_code IN ('03', '08')) -- Deduction and pay element processing groups pay elements
            --ORDER BY ppsq.pyrl_processing_seq_entry_nbr
            --       , pay_element_id
        ),
        deduction_cte  (
                         emp_id
                       , payroll_run_type_id
                       , pay_pd_id
                       , pmt_seq_nbr
                       , pay_element_id
                       , PayPeriodEndDate
                       , HROrganization
                       , Employee
                       , EffectiveDate
                       , CheckDate
                       , CheckID
                       , DeductionType
                       , DeductionCodeDescription
                       , DeductionAmount
                       , YearToDateDeductionAmount
                       , deduction_type_code
                       , bank_id
                       , bank_acct_nbr
                       , DeductionCodeDesc2
                       )
        AS
        (
            SELECT chk.emp_id
                , chk.payroll_run_type_id
                , chk.pay_pd_id
                , chk.pmt_seq_nbr
                , ele.pay_element_id
                , chk.PayPeriodEndDate

                , chk.HROrganization                   -- HROrganization
                , chk.emp_id                           -- Employee
                , chk.EffectiveDate                    -- Effective_date
                , chk.CheckDate                        -- CheckDate
                , chk.CheckID                          -- CheckID
                --, row_number() OVER(PARTITION BY chk.emp_id, chk.pay_pd_id ORDER BY chk.CheckID, chk.PayPeriodEndDate, ele.pay_element_id) as row_nbr -- CheckEarning (counter)
                , 'o' AS DeductionType                 -- DeductionType
                , descp.short_descp                    -- DeductionCodeDescription
                , ele.tot_current_monetary_amt         -- DeductionAmount
                , ele.ytd_monetary_amt                 -- YearToDateDeductionAmount
                , ele.deduction_type_code
                , ISNULL(disbdtl.bank_id, '') AS bank_id
                , ISNULL(disbdtl.bank_acct_nbr, '') AS bank_acct_nbr
                , descp.short_descp                    -- DeductionCodeDesc2

            FROM dbo.ghr_pay_check chk
            JOIN DBShrpy.dbo.emp_pmt_pay_element_detail ele on
                (chk.emp_id              = ele.emp_id) AND
                (chk.payroll_run_type_id = ele.payroll_run_type_id) AND
                (chk.pay_pd_id           = ele.pay_pd_id) AND
                (chk.pmt_seq_nbr         = ele.pmt_seq_nbr)
            JOIN DBShrpn.dbo.pay_element pe ON
                (ele.pay_element_id              = pe.pay_element_id)
            JOIN DBShrpn.dbo.pay_element_descp descp ON
                (pe.pay_element_id   = descp.pay_element_id) AND
                (pe.eff_date         = descp.eff_date)
            LEFT JOIN DBShrpy.dbo.emp_pmt_disbursal_detail disbdtl on
                (ele.emp_id              = disbdtl.emp_id) AND
                (ele.payroll_run_type_id = disbdtl.payroll_run_type_id) AND
                (ele.pay_pd_id           = disbdtl.pay_pd_id) AND
                (ele.pmt_seq_nbr         = disbdtl.pmt_seq_nbr) AND
                (ele.pay_element_id      = disbdtl.pay_element_id)

            WHERE (ele.pmt_detail_type_code = '1')      -- Pay Element
            AND (ele.pay_element_type_code = '2')     -- Deduction Type Code
            --AND (ele.deduction_type_code <> '3')    -- Direct Deposit Type Code
            --AND (ele.pay_element_id <> 'DPAYE')   -- Exclude taxes
            AND (pe.next_eff_date          = @v_END_OF_TIME_DATE)
            AND (descp.language_code       = @V_ENGLISH_LANG_CODE)
        )
        INSERT INTO dbo.ghr_pay_check_deduction
        SELECT ded.emp_id
            , ded.payroll_run_type_id
            , ded.pay_pd_id
            , ded.pmt_seq_nbr
            , ded.pay_element_id

            , ded.HROrganization                   -- HROrganization
            , ded.Employee                         -- Employee
            , ded.EffectiveDate                    -- Effective_date
            , ded.CheckDate                        -- CheckDate
            , ded.CheckID                          -- CheckID
            , row_number() OVER(PARTITION BY ded.emp_id, ded.pay_pd_id ORDER BY ded.CheckID, ded.PayPeriodEndDate, seq.pyrl_processing_seq_entry_nbr, ded.pay_element_id) AS row_nbr -- CheckEarning (counter)
            , ded.DeductionType                    -- DeductionType
            , ded.pay_element_id                   -- DeductionCodeDescription
            , ded.DeductionAmount                  -- DeductionAmount
            , ded.YearToDateDeductionAmount        -- YearToDateDeductionAmount
            , CASE ded.deduction_type_code
                WHEN '3' THEN CASE
                                WHEN (CHARINDEX(ded.pay_element_id, 'CHILD') > 0) THEN 'ChildSupp -'
                                WHEN (ded.pay_element_id = 'DD1') THEN 'NetBank -'
                                ELSE ''
                            END + ' ' + RTRIM(ded.bank_id) + ' - ' + RTRIM(ded.bank_acct_nbr)
                ELSE ded.DeductionCodeDescription
            END AS DeductionCodeDesc2
        FROM deduction_cte ded
        LEFT JOIN seq_cte seq ON
            (ded.pay_element_id = seq.pay_element_id)
        ORDER BY ded.emp_id
            , ded.payroll_run_type_id
            , ded.pay_pd_id
            , ded.pmt_seq_nbr
            , seq.pyrl_processing_seq_entry_nbr
            , ded.pay_element_id


        SET @v_rowcount = @@ROWCOUNT

        SET @v_msg = 'Deduction Rows inserted into table DBShrpn.dbo.ghr_pay_check_deduction: (' + CONVERT(varchar(18), @v_rowcount) + ') '
        EXEC DBSpscb.dbo.psp_ins_psc_putmsg_2
              @userid   = @v_userid
            , @batch    = @v_PSC_BATCHNAME
            , @qual     = @v_PSC_QUALIFIER
            , @msgno    = 'U00011'  -- Blank message id text
            , @severity = 0
            , @text     = @v_msg
            , @text_2   = ''
            , @text_3   = ''


    END TRY
    BEGIN CATCH

        SELECT @ErrorNumber   = CAST(ERROR_NUMBER() AS varchar(10))
             , @ErrorMessage  = @v_step_position + ' - ' + ERROR_MESSAGE()
             , @ErrorSeverity = ERROR_SEVERITY()
             , @ErrorState    = ERROR_STATE()
             , @v_ret_val      = -1


        EXEC DBSpscb.dbo.psp_ins_psc_putmsg_2
              @userid   = @v_userid
            , @batch    = @v_PSC_BATCHNAME
            , @qual     = @v_PSC_QUALIFIER
            , @msgno    = @ErrorNumber
            , @severity = @ErrorSeverity
            , @text     = @ErrorMessage
            , @text_2   = ''
            , @text_3   = ''


    END CATCH


    RETURN @v_ret_val


END  -- End of SP

GO
ALTER AUTHORIZATION ON dbo.usp_pay_stmt_main_extract TO SCHEMA OWNER
GO


IF OBJECT_ID(N'dbo.usp_pay_stmt_main_extract', N'P') IS NOT NULL
    PRINT N'<<< CREATED PROCEDURE dbo.usp_pay_stmt_main_extract >>>'
ELSE
    PRINT N'<<< FAILED CREATING PROCEDURE dbo.usp_pay_stmt_main_extract >>>'
GO

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
        @p_cal_yr               = Calendar Year
		@p_payroll_run_type_id	= Payroll Run Type ID
		@p_pay_pd_id			= Payroll Period ID
		@p_emp_id				= Employee ID - For debugging purposes only, will typically be null to pull all employees

    Tables:
        DBShrpy.dbo.emp_pmt
        DBShrpy.dbo.emp_pmt_disbursal_detail
        DBShrpy.dbo.emp_pmt_pay_element_detail
        DBShrpy.dbo.emp_pay_element_accum

        DBShrpn.dbo.ghr_pay_check
        DBShrpn.dbo.ghr_pay_check_earning
        DBShrpn.dbo.ghr_pay_check_deduction
        DBShrpn.dbo.ghr_pay_check_ach


    Example:
         EXEC DBShrpn.dbo.usp_pay_stmt_main_extract
              @p_cal_yr                 = 2025
            , @p_payroll_run_type_id    = 'MONTHLY'
            , @p_pay_pd_id              = '1 2020'
            , @p_emp_id                 = '10236'


   Revision history:
   version  date        developer   SCR         description
   -------  ----------  ---------   -----       ------------------------------------
   1.0.00   05/05/2026  CJP                     - Created procedure

************************************************************************************/
CREATE procedure dbo.usp_pay_stmt_main_extract
(
        @p_cal_yr                   int
    ,   @p_payroll_run_type_id      char(10)    = NULL
    ,   @p_pay_pd_id                char(10)    = NULL
    ,   @p_emp_id                   char(15)    = NULL -- For debug purposes
)

AS

BEGIN

    SET NOCOUNT ON


    DECLARE @v_END_OF_TIME_DATE         datetime            = '29991231'
    DECLARE @V_ENGLISH_LANG_CODE        char(5)             = 'EN' -- English


    ---------------------------------------------------------------------------
    -- Delete previous generated records
    ---------------------------------------------------------------------------
    DELETE FROM dbo.ghr_pay_check



    ---------------------------------------------------------------------------
    -- Header ViewEmployeePayCheck
    ---------------------------------------------------------------------------
    INSERT INTO dbo.ghr_pay_check
    SELECT pmt.emp_id
         , pmt.payroll_run_type_id
         , pmt.pay_pd_id
         , pmt.pmt_seq_nbr
         , pmt.seq_ctrl_yr

         , pmt.check_date                           -- EffectiveDate
         , 'GOSL' AS hr_org                         -- HROrganization
         , pmt.emp_id                               -- Employee
         , pmt.check_date                          -- CheckDate
         , MAX(dsb.check_or_deposit_advice_nbr) AS CheckNumber          -- CheckNumber
         , pmt.pay_pd_id                            -- PayPeriodID
         , pmt.pay_pd_begin_date                    -- PayPeriodDateRange.BeginDate
         , pmt.pay_pd_end_date                      -- PayPeriodDateRange.EndDate
         , pmt.pmt_net_pay_amt                      -- NetPayAmount
         , pmt.ytd_net_pay_amt                      -- YearToDateNetPay
         , pmt.pmt_net_pay_amt                      -- CheckNetAmount
         , pmt.ytd_net_pay_amt                      -- YearToDateCheckNet
         , pmt.pmt_tot_gross_pay_amt                    -- GrossPayAmount
         , pmt.pmt_tot_gross_pay_amt                    -- YearToDateGrossPay
         , 0.00 AS taxable_amt                      -- Taxable
         , 0.00 AS ytd_taxable_amt                  -- YearToDateTaxable
         , SUM(dsb.disbursal_amt) AS TotalACH                  -- TotalACH
         , pmt.pmt_tot_deductions_wh_amt - ISNULL(ele.tot_current_monetary_amt, 0.00) AS TotalOtherDeductions              -- TotalOtherDeductions
         , pmt.pmt_tot_deductions_wh_amt - ISNULL(ele.tot_current_monetary_amt, 0.00) AS TotalCheckDeductions              -- TotalCheckDeductions
         , ISNULL(ele.tot_current_monetary_amt, 0.00) AS TotalTaxDeductions               -- TotalTaxDeductions ("DPAYE)
         , pmt.ytd_tot_deductions_wh_amt  - ISNULL(ele.ytd_monetary_amt, 0.00) AS TotalYearToDateDeductions             -- TotalYearToDateDeductions
         , MAX(dsb.check_or_deposit_advice_nbr) AS CheckID          -- CheckID
         , 'M' AS 'check_type'                      -- CheckType

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

    WHERE (dsb.pmt_meth_id = 'DDPST')
	  AND (pmt.seq_ctrl_yr = @p_cal_yr)

	  AND (pmt.emp_pmt_status_code        = '05')       -- Completely disbursed
      AND (pmt.pmt_type_code <> '04')                   -- Exclude reversals
      AND (dsb.doc_disbursal_status_code <> '06')       -- Exclude voids due to overflows on earnings statement
	  AND (
			(@p_payroll_run_type_id IS NULL) OR
			(
			 (@p_payroll_run_type_id IS NOT NULL) AND
			 (pmt.payroll_run_type_id = @p_payroll_run_type_id)
			)
		  )
	  AND (
			(@p_pay_pd_id IS NULL) OR
			(
			 (@p_pay_pd_id IS NOT NULL) AND
			 (pmt.pay_pd_id = @p_pay_pd_id)
			)
		  )
      AND (  -- associate id
           (@p_emp_id IS NULL) OR
           (
            (@p_emp_id IS NOT NULL) AND
            (pmt.emp_id = @p_emp_id)
           )
          )
    GROUP BY pmt.emp_id
         , pmt.payroll_run_type_id
         , pmt.pay_pd_id
         , pmt.pmt_seq_nbr
         , pmt.seq_ctrl_yr
         , pmt.check_date
         , pmt.check_date                          -- CheckDate
         , pmt.pay_pd_begin_date                    -- PayPeriodDateRange.BeginDate
         , pmt.pay_pd_end_date                      -- PayPeriodDateRange.EndDate
         , pmt.pmt_net_pay_amt                      -- NetPayAmount
         , pmt.ytd_net_pay_amt                      -- YearToDateNetPay
         , pmt.pmt_tot_gross_pay_amt                    -- GrossPayAmount
         , pmt.ytd_tot_gross_pay_amt                    -- YearToDateGrossPay
         , pmt.pmt_tot_deductions_wh_amt
         , pmt.ytd_tot_deductions_wh_amt
         , ele.tot_current_monetary_amt
         , ele.ytd_monetary_amt



    ---------------------------------------------------------------------------
	-- ViewEmployeePayCheckEarning
    ---------------------------------------------------------------------------
    INSERT INTO dbo.ghr_pay_check_earning
    SELECT chk.emp_id
         , chk.payroll_run_type_id
         , chk.pay_pd_id
         , chk.pmt_seq_nbr
         , ele.pay_element_id

         , chk.EffectiveDate                    -- Effective_date
         , chk.HROrganization                   -- HROrganization
         , chk.emp_id                           -- Employee
         , chk.CheckDate                        -- CheckDate
         , chk.CheckID                          -- CheckID
         , row_number() OVER(PARTITION BY chk.emp_id, chk.pay_pd_id ORDER BY chk.CheckID, chk.PayPeriodEndDate, ele.pay_element_id) as row_nbr -- CheckEarning (counter)
         , descp.short_descp                    -- Description
         , 0.00                                 -- Hours
         , ele.tot_current_monetary_amt         -- EarningsAmount
         , chk.PayPeriodBeginDate               -- BeginDate
         , chk.PayPeriodEndDate                 -- EndDate
         , ele.ytd_monetary_amt                 -- YearToDateEarningsAmount
         , 0.00                                 -- YearToDateHours

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


    ---------------------------------------------------------------------------
	-- ViewEmployeePayCheckDeduction
    ---------------------------------------------------------------------------
    INSERT INTO dbo.ghr_pay_check_deduction
    SELECT chk.emp_id
         , chk.payroll_run_type_id
         , chk.pay_pd_id
         , chk.pmt_seq_nbr
         , ele.pay_element_id

         , chk.EffectiveDate                    -- Effective_date
         , chk.HROrganization                   -- HROrganization
         , chk.emp_id                           -- Employee
         , chk.CheckDate                        -- CheckDate
         , chk.CheckID                          -- CheckID
         , row_number() OVER(PARTITION BY chk.emp_id, chk.pay_pd_id ORDER BY chk.CheckID, chk.PayPeriodEndDate, ele.pay_element_id) as row_nbr -- CheckEarning (counter)
         , 'o' AS DeductionType                 -- DeductionType
         , descp.short_descp                   -- DeductionCodeDescription
         , ele.tot_current_monetary_amt         -- DeductionAmount
         , ele.ytd_monetary_amt                 -- YearToDateDeductionAmount

		 --, ele.pay_element_type_code
		 --, ele.deduction_type_code
		 --, ele.earn_type_code

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
    WHERE (ele.pmt_detail_type_code = '1')      -- Pay Element
      AND (ele.pay_element_type_code = '2')     -- Deduction Type Code
	  AND (ele.deduction_type_code <> '3')
      AND (ele.pay_element_id <> 'DPAYE')   -- Exclude taxes
      AND (pe.next_eff_date          = @v_END_OF_TIME_DATE)
      AND (descp.language_code       = @V_ENGLISH_LANG_CODE)

	---------------------------------------------------------------------------
    -- ViewEmployeePayCheckACH
    ---------------------------------------------------------------------------
    INSERT INTO dbo.ghr_pay_check_ach
    SELECT chk.emp_id
         , chk.payroll_run_type_id
         , chk.pay_pd_id
         , chk.pmt_seq_nbr
         , ele.pay_element_id

         , chk.EffectiveDate                    -- Effective_date
         , chk.HROrganization                   -- HROrganization
         , chk.emp_id                           -- Employee
         , chk.CheckDate                        -- CheckDate
         , chk.CheckID                          -- CheckID
         , row_number() OVER(PARTITION BY chk.emp_id, chk.pay_pd_id ORDER BY chk.CheckID, chk.PayPeriodEndDate, ele.pay_element_id) as row_nbr -- CheckACH (counter)
         , ele.pay_element_id                   -- Description
         , ele.tot_current_monetary_amt         -- DistributionAmount
    FROM dbo.ghr_pay_check chk
    JOIN DBShrpy.dbo.emp_pmt_pay_element_detail ele on
        (chk.emp_id              = ele.emp_id) AND
        (chk.payroll_run_type_id = ele.payroll_run_type_id) AND
        (chk.pay_pd_id           = ele.pay_pd_id) AND
        (chk.pmt_seq_nbr         = ele.pmt_seq_nbr)
    WHERE (ele.pmt_detail_type_code = '1')      -- Pay Element
      AND (ele.pay_element_type_code = '2')     -- Earnings Type Code
      AND (ele.deduction_type_code = '3')     -- Direct Deposit Type Code


END  -- End of SP

GO
ALTER AUTHORIZATION ON dbo.usp_pay_stmt_main_extract TO SCHEMA OWNER
GO


IF OBJECT_ID(N'dbo.usp_pay_stmt_main_extract', N'P') IS NOT NULL
    PRINT N'<<< CREATED PROCEDURE dbo.usp_pay_stmt_main_extract >>>'
ELSE
    PRINT N'<<< FAILED CREATING PROCEDURE dbo.usp_pay_stmt_main_extract >>>'
GO

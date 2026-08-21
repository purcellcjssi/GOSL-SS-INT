USE DBShrpn
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID(N'dbo.usp_pay_stmt_pay_chk_csv', N'P') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.usp_pay_stmt_pay_chk_csv
    IF OBJECT_ID(N'dbo.usp_pay_stmt_pay_chk_csv') IS NOT NULL
        PRINT N'<<< FAILED DROPPING PROCEDURE dbo.usp.usp_pay_stmt_pay_chk_csv >>>'
    ELSE
        PRINT N'<<< DROPPED PROCEDURE dbo.usp_pay_stmt_pay_chk_csv >>>'
END
GO

/*************************************************************************************

    SP Name:
        usp_pay_stmt_pay_chk_csv

    Description:
        SmartStream to HCM Cloud Suite Pay Check Extract Interface



    Parameters:
        None

    Tables:
        DBShrpn.dbo.ghr_pay_check

    Example:
         DBShrpn.dbo.usp_pay_stmt_pay_chk_csv



   Revision history:
   version  date        developer   SCR         description
   -------  ----------  ---------   -----       ------------------------------------
   1.0.00   05/06/2026  CJP                     - Created procedure

************************************************************************************/
CREATE PROCEDURE dbo.usp_pay_stmt_pay_chk_csv

AS

BEGIN

    SET NOCOUNT ON

    ---------------------------------------------------------------------------
    -- Export Header Record
    ---------------------------------------------------------------------------
    SELECT 'EffectiveDate'                  AS 'EffectiveDate'
         , 'HROrganization'                 AS 'HROrganization'
         , 'Employee'                       AS 'Employee'
         , 'CheckDate'                      AS 'CheckDate'
         , 'CheckNumber'                    AS 'CheckNumber'
         , 'PayPeriodID'                    AS 'PayPeriodID'
         , 'PayPeriodBeginDate'             AS 'PayPeriodBeginDate'
         , 'PayPeriodEndDate'               AS 'PayPeriodEndDate'
         , 'NetPayAmount'                   AS 'NetPayAmount'
         , 'YearToDateNetPay'               AS 'YearToDateNetPay'
         , 'CheckNetAmount'                 AS 'CheckNetAmount'
         , 'YearToDateCheckNet'             AS 'YearToDateCheckNet'
         , 'GrossPayAmount'                 AS 'GrossPayAmount'
         , 'YearToDateGrossPay'             AS 'YearToDateGrossPay'
         , 'Taxable'                        AS 'Taxable'
         , 'YearToDateTaxable'              AS 'YearToDateTaxable'
         , 'TotalACH'                       AS 'TotalACH'
         , 'TotalOtherDeductions'           AS 'TotalOtherDeductions'
         , 'TotalCheckDeductions'           AS 'TotalCheckDeductions'
         , 'TotalTaxDeductions'             AS 'TotalTaxDeductions'
         , 'TotalYearToDateDeductions'      AS 'TotalYearToDateDeductions'
         , 'CheckID'                        AS 'CheckID'
         , 'CheckType'                      AS 'CheckType'
    UNION ALL
    SELECT CONVERT(varchar(10), EffectiveDate, 112)
         , HROrganization
         , Employee
         , CONVERT(varchar(10), CheckDate, 112)
         , CheckNumber
         , RTRIM(PayPeriodID)
         , CONVERT(varchar(10), PayPeriodBeginDate, 112)
         , CONVERT(varchar(10), PayPeriodEndDate, 112)
         , CONVERT(varchar(10), NetPayAmount, 0)
         , CONVERT(varchar(10), YearToDateNetPay, 0)
         , CONVERT(varchar(10), CheckNetAmount, 0)
         , CONVERT(varchar(10), YearToDateCheckNet, 0)
         , CONVERT(varchar(10), GrossPayAmount, 0)
         , CONVERT(varchar(10), YearToDateGrossPay, 0)
         , CONVERT(varchar(10), Taxable, 0)
         , CONVERT(varchar(10), YearToDateTaxable, 0)
         , CONVERT(varchar(10), TotalACH, 0)
         , CONVERT(varchar(10), TotalOtherDeductions, 0)
         , CONVERT(varchar(10), TotalCheckDeductions, 0)
         , CONVERT(varchar(10), TotalTaxDeductions, 0)
         , CONVERT(varchar(10), TotalYearToDateDeductions, 0)
         , CheckID
         , CheckType
    FROM dbo.ghr_pay_check

END  -- End of SP

GO
ALTER AUTHORIZATION ON dbo.usp_pay_stmt_pay_chk_csv TO SCHEMA OWNER
GO


IF OBJECT_ID(N'dbo.usp_pay_stmt_pay_chk_csv', N'P') IS NOT NULL
    PRINT N'<<< CREATED PROCEDURE dbo.usp_pay_stmt_pay_chk_csv >>>'
ELSE
    PRINT N'<<< FAILED CREATING PROCEDURE dbo.usp_pay_stmt_pay_chk_csv >>>'
GO

USE DBShrpn
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID(N'dbo.usp_pay_stmt_pay_chk_earn_csv', N'P') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.usp_pay_stmt_pay_chk_earn_csv
    IF OBJECT_ID(N'dbo.usp_pay_stmt_pay_chk_earn_csv') IS NOT NULL
        PRINT N'<<< FAILED DROPPING PROCEDURE dbo.usp_pay_stmt_pay_chk_earn_csv >>>'
    ELSE
        PRINT N'<<< DROPPED PROCEDURE dbo.usp_pay_stmt_pay_chk_earn_csv >>>'
END
GO

/*************************************************************************************

    SP Name:
        usp_pay_stmt_pay_chk_earn_csv

    Description:
        SmartStream to HCM Cloud Suite Pay Check Extract Interface



    Parameters:
        None

    Tables:
        DBShrpn.dbo.ghr_pay_check_earning


    Example:
         DBShrpn.dbo.usp_pay_stmt_pay_chk_earn_csv



   Revision history:
   version  date        developer   SCR         description
   -------  ----------  ---------   -----       ------------------------------------
   1.0.00   05/06/2026  CJP                     - Created procedure

************************************************************************************/
CREATE PROCEDURE dbo.usp_pay_stmt_pay_chk_earn_csv

AS

BEGIN

    SET NOCOUNT ON


    ---------------------------------------------------------------------------
    -- Export Earnings Records
    ---------------------------------------------------------------------------
    SELECT 'EffectiveDate'              AS 'EffectiveDate'
         , 'HROrganization'             AS 'HROrganization'
         , 'Employee'                   AS 'Employee'
         , 'CheckDate'                  AS 'CheckDate'
         , 'CheckID'                    AS 'CheckID'
         , 'CheckEarningCounter'        AS 'CheckEarningCounter'
         , 'EarningsDescription'        AS 'EarningsDescription'
         , 'EarningsHours'              AS 'EarningsHours'
         , 'EarningsAmount'             AS 'EarningsAmount'
         , 'BeginDate'                  AS 'BeginDate'
         , 'EndDate'                    AS 'EndDate'
         , 'YearToDateEarningsAmount'   AS 'YearToDateEarningsAmount'
         , 'YearToDateHours'            AS 'YearToDateHours'
    UNION ALL
    SELECT CONVERT(varchar(10), EffectiveDate, 112)
         , HROrganization
         , Employee
         , CONVERT(varchar(10), CheckDate, 112)
         , CheckID
         , CONVERT(varchar(10), CheckEarningCounter)
         , RTRIM(EarningsDescription)
         , CONVERT(varchar(18), EarningsHours, 0)
         , CONVERT(varchar(18), EarningsAmount, 0)
         , CONVERT(varchar(10), BeginDate, 112)
         , CONVERT(varchar(10), EndDate, 112)
         , CONVERT(varchar(18), YearToDateEarningsAmount, 0)
         , CONVERT(varchar(18), YearToDateHours, 0)
    FROM dbo.ghr_pay_check_earning



END  -- End of SP

GO
ALTER AUTHORIZATION ON dbo.usp_pay_stmt_pay_chk_earn_csv TO SCHEMA OWNER
GO


IF OBJECT_ID(N'dbo.usp_pay_stmt_pay_chk_earn_csv', N'P') IS NOT NULL
    PRINT N'<<< CREATED PROCEDURE dbo.usp_pay_stmt_pay_chk_earn_csv >>>'
ELSE
    PRINT N'<<< FAILED CREATING PROCEDURE dbo.usp_pay_stmt_pay_chk_earn_csv >>>'
GO

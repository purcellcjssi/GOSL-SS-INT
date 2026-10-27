USE DBShrpn
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID(N'dbo.usp_pay_stmt_earn_export', N'P') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.usp_pay_stmt_earn_export
    IF OBJECT_ID(N'dbo.usp_pay_stmt_earn_export') IS NOT NULL
        PRINT N'<<< FAILED DROPPING PROCEDURE dbo.usp_pay_stmt_earn_export >>>'
    ELSE
        PRINT N'<<< DROPPED PROCEDURE dbo.usp_pay_stmt_earn_export >>>'
END
GO

/*************************************************************************************

    SP Name:
        usp_pay_stmt_earn_export

    Description:
        SmartStream to HCM Cloud Suite Pay Check Extract Interface



    Parameters:
        None

    Tables:
        DBShrpn.dbo.ghr_pay_check_earning


    Example:
         DBShrpn.dbo.usp_pay_stmt_earn_export



   Revision history:
   version  date        developer   SCR         description
   -------  ----------  ---------   -----       ------------------------------------
   1.0.00   05/06/2026  CJP                     - Created procedure

************************************************************************************/
CREATE PROCEDURE dbo.usp_pay_stmt_earn_export

AS

BEGIN

    SET NOCOUNT ON


    ---------------------------------------------------------------------------
    -- Export Earnings Records
    ---------------------------------------------------------------------------
    /*SELECT 'HROrganization'
         + '^Employee'
         + '^EffectiveDate'
         + '^CheckDate'
         + '^CheckID'
         + '^CheckEarningCounter'
         + '^EarningsDescription'
         + '^EarningsAmount'
         + '^BeginDate'
         + '^EndDate'
         + '^YearToDateEarningsAmount'
    UNION ALL
    */
    SELECT HROrganization
         + '^' + RTRIM(Employee)
         + '^' + CONVERT(varchar(10), EffectiveDate, 112)
         + '^' + CONVERT(varchar(10), CheckDate, 112)
         + '^' + RTRIM(CheckID)
         + '^' + CONVERT(varchar(10), CheckEarningCounter)
         + '^' + RTRIM(EarningsDescription)
         + '^' + CONVERT(varchar(18), EarningsAmount, 0)
         + '^' + CONVERT(varchar(10), BeginDate, 112)
         + '^' + CONVERT(varchar(10), EndDate, 112)
         + '^' + CONVERT(varchar(18), YearToDateEarningsAmount, 0)
    FROM dbo.ghr_pay_check_earning



END  -- End of SP

GO
ALTER AUTHORIZATION ON dbo.usp_pay_stmt_earn_export TO SCHEMA OWNER
GO


IF OBJECT_ID(N'dbo.usp_pay_stmt_earn_export', N'P') IS NOT NULL
    PRINT N'<<< CREATED PROCEDURE dbo.usp_pay_stmt_earn_export >>>'
ELSE
    PRINT N'<<< FAILED CREATING PROCEDURE dbo.usp_pay_stmt_earn_export >>>'
GO

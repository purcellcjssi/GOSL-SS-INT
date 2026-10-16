USE DBShrpn
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID(N'dbo.usp_pay_stmt_hdr_export', N'P') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.usp_pay_stmt_hdr_export
    IF OBJECT_ID(N'dbo.usp_pay_stmt_hdr_export') IS NOT NULL
        PRINT N'<<< FAILED DROPPING PROCEDURE dbo.usp.usp_pay_stmt_hdr_export >>>'
    ELSE
        PRINT N'<<< DROPPED PROCEDURE dbo.usp_pay_stmt_hdr_export >>>'
END
GO

/*************************************************************************************

    SP Name:
        usp_pay_stmt_hdr_export

    Description:
        SmartStream to HCM Cloud Suite Pay Check Extract Interface



    Parameters:
        None

    Tables:
        DBShrpn.dbo.ghr_pay_check

    Example:
         EXEC DBShrpn.dbo.usp_pay_stmt_hdr_export



   Revision history:
   version  date        developer   SCR         description
   -------  ----------  ---------   -----       ------------------------------------
   1.0.00   05/06/2026  CJP                     - Created procedure

************************************************************************************/
CREATE PROCEDURE dbo.usp_pay_stmt_hdr_export

AS

BEGIN

    SET NOCOUNT ON

    ---------------------------------------------------------------------------
    -- Export Header Record
    ---------------------------------------------------------------------------
    SELECT 'HROrganization'
         + '^Employee'
         + '^EffectiveDate'
         + '^CheckID'
         + '^CheckNumber'
         + '^NetPayAmount'
         + '^YearToDateNetPay'
         + '^CheckDate'
         + '^PayPeriodBeginDate'
         + '^PayPeriodEndDate'
         + '^CheckNetAmount'
         + '^GrossPayAmount'
         + '^YearToDateGrossPay'
         + '^TotalCheckDeductions'
         + '^TotalYearToDateDeductions'
    UNION ALL
    SELECT HROrganization
         + '^' + RTRIM(Employee)
         + '^' + CONVERT(varchar(10), EffectiveDate, 112)
         + '^' + RTRIM(CheckID)
         + '^' + RTRIM(CheckNumber)
         + '^' + CONVERT(varchar(10), NetPayAmount, 0)
         + '^' + CONVERT(varchar(10), YearToDateNetPay, 0)
         + '^' + CONVERT(varchar(10), CheckDate, 112)
         + '^' + CONVERT(varchar(10), PayPeriodBeginDate, 112)
         + '^' + CONVERT(varchar(10), PayPeriodEndDate, 112)
         + '^' + CONVERT(varchar(10), CheckNetAmount, 0)
         + '^' + CONVERT(varchar(10), GrossPayAmount, 0)
         + '^' + CONVERT(varchar(10), YearToDateGrossPay, 0)
         + '^' + CONVERT(varchar(10), TotalCheckDeductions, 0)
         + '^' + CONVERT(varchar(10), TotalYearToDateDeductions, 0)
    FROM dbo.ghr_pay_check

END  -- End of SP

GO
ALTER AUTHORIZATION ON dbo.usp_pay_stmt_hdr_export TO SCHEMA OWNER
GO


IF OBJECT_ID(N'dbo.usp_pay_stmt_hdr_export', N'P') IS NOT NULL
    PRINT N'<<< CREATED PROCEDURE dbo.usp_pay_stmt_hdr_export >>>'
ELSE
    PRINT N'<<< FAILED CREATING PROCEDURE dbo.usp_pay_stmt_hdr_export >>>'
GO

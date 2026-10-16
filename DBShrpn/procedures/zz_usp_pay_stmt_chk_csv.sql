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
         EXEC DBShrpn.dbo.usp_pay_stmt_pay_chk_csv



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
    SELECT 'HROrganization'                 AS 'HROrganization'
         , 'Employee'                       AS 'Employee'
         , 'EffectiveDate'                  AS 'EffectiveDate'
         , 'CheckID'                        AS 'CheckID'
         , 'CheckNumber'                    AS 'CheckNumber'
         , 'NetPayAmount'                   AS 'NetPayAmount'
         , 'YearToDateNetPay'               AS 'YearToDateNetPay'
         , 'CheckDate'                      AS 'CheckDate'
         , 'PayPeriodBeginDate'             AS 'PayPeriodBeginDate'
         , 'PayPeriodEndDate'               AS 'PayPeriodEndDate'
         , 'CheckNetAmount'                 AS 'CheckNetAmount'
         , 'GrossPayAmount'                 AS 'GrossPayAmount'
         , 'YearToDateGrossPay'             AS 'YearToDateGrossPay'
         , 'TotalCheckDeductions'           AS 'TotalCheckDeductions'
         , 'TotalYearToDateDeductions'      AS 'TotalYearToDateDeductions'
    UNION ALL
    SELECT HROrganization
         , Employee
         , CONVERT(varchar(10), EffectiveDate, 112)
         , CheckID
         , CheckNumber
         , CONVERT(varchar(10), NetPayAmount, 0)
         , CONVERT(varchar(10), YearToDateNetPay, 0)
         , CONVERT(varchar(10), CheckDate, 112)
         , CONVERT(varchar(10), PayPeriodBeginDate, 112)
         , CONVERT(varchar(10), PayPeriodEndDate, 112)
         , CONVERT(varchar(10), CheckNetAmount, 0)
         , CONVERT(varchar(10), GrossPayAmount, 0)
         , CONVERT(varchar(10), YearToDateGrossPay, 0)
         , CONVERT(varchar(10), TotalCheckDeductions, 0)
         , CONVERT(varchar(10), TotalYearToDateDeductions, 0)
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

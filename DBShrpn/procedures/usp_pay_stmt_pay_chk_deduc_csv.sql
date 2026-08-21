USE DBShrpn
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID(N'dbo.usp_pay_stmt_pay_chk_deduc_csv', N'P') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.usp_pay_stmt_pay_chk_deduc_csv
    IF OBJECT_ID(N'dbo.usp_pay_stmt_pay_chk_deduc_csv') IS NOT NULL
        PRINT N'<<< FAILED DROPPING PROCEDURE dbo.usp.usp_pay_stmt_pay_chk_deduc_csv >>>'
    ELSE
        PRINT N'<<< DROPPED PROCEDURE dbo.usp_pay_stmt_pay_chk_deduc_csv >>>'
END
GO

/*************************************************************************************

    SP Name:
        usp_pay_stmt_pay_chk_deduc_csv

    Description:
        SmartStream to HCM Cloud Suite Pay Check Extract Interface



    Parameters:
        None

    Tables:
        DBShrpn.dbo.ghr_pay_check_deduction


    Example:
         EXEC DBShrpn.dbo.usp_pay_stmt_pay_chk_deduc_csv



   Revision history:
   version  date        developer   SCR         description
   -------  ----------  ---------   -----       ------------------------------------
   1.0.00   05/06/2026  CJP                     - Created procedure

************************************************************************************/
CREATE PROCEDURE dbo.usp_pay_stmt_pay_chk_deduc_csv

AS

BEGIN

    SET NOCOUNT ON

    ---------------------------------------------------------------------------
    -- Export Deductions Records
    ---------------------------------------------------------------------------
    SELECT 'EffectiveDate'              AS 'EffectiveDate'
         , 'HROrganization'             AS 'HROrganization'
         , 'Employee'                   AS 'Employee'
         , 'CheckDate'                  AS 'CheckDate'
         , 'CheckID'                    AS 'CheckID'
         , 'CheckDeductionCounter'       AS 'CheckDeductionCounter'
         , 'DeductionType'               AS 'DeductionType'
         , 'DeductionDescription'        AS 'DeductionDescription'
         , 'DeductionAmount'             AS 'DeductionAmount'
         , 'TotalYearToDateDeductionAmount' AS 'TotalYearToDateDeductionAmount'
    UNION ALL
    SELECT CONVERT(varchar(10), EffectiveDate, 112)
         , HROrganization
         , Employee
         , CONVERT(varchar(10), CheckDate, 112)
         , CheckID
         , CONVERT(varchar(10), CheckDeductionCounter)
         , DeductionType
         , RTRIM(DeductionDescription)
         , CONVERT(varchar(18),DeductionAmount,0)
         , CONVERT(varchar(18),YearToDateDeductionAmount,0)
    FROM dbo.ghr_pay_check_deduction


END  -- End of SP

GO
ALTER AUTHORIZATION ON dbo.usp_pay_stmt_pay_chk_deduc_csv TO SCHEMA OWNER
GO


IF OBJECT_ID(N'dbo.usp_pay_stmt_pay_chk_deduc_csv', N'P') IS NOT NULL
    PRINT N'<<< CREATED PROCEDURE dbo.usp_pay_stmt_pay_chk_deduc_csv >>>'
ELSE
    PRINT N'<<< FAILED CREATING PROCEDURE dbo.usp_pay_stmt_pay_chk_deduc_csv >>>'
GO

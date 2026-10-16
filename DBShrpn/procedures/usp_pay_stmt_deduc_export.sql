USE DBShrpn
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID(N'dbo.usp_pay_stmt_deduc_export', N'P') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.usp_pay_stmt_deduc_export
    IF OBJECT_ID(N'dbo.usp_pay_stmt_deduc_export') IS NOT NULL
        PRINT N'<<< FAILED DROPPING PROCEDURE dbo.usp.usp_pay_stmt_deduc_export >>>'
    ELSE
        PRINT N'<<< DROPPED PROCEDURE dbo.usp_pay_stmt_deduc_export >>>'
END
GO

/*************************************************************************************

    SP Name:
        usp_pay_stmt_deduc_export

    Description:
        SmartStream to HCM Cloud Suite Pay Check Extract Interface



    Parameters:
        None

    Tables:
        DBShrpn.dbo.ghr_pay_check_deduction


    Example:
         EXEC DBShrpn.dbo.usp_pay_stmt_deduc_export



   Revision history:
   version  date        developer   SCR         description
   -------  ----------  ---------   -----       ------------------------------------
   1.0.00   05/06/2026  CJP                     - Created procedure

************************************************************************************/
CREATE PROCEDURE dbo.usp_pay_stmt_deduc_export

AS

BEGIN

    SET NOCOUNT ON

    ---------------------------------------------------------------------------
    -- Export Deductions Records
    ---------------------------------------------------------------------------
    SELECT 'HROrganization'
         +  '^Employee'
         +  '^EffectiveDate'
         +  '^CheckDate'
         +  '^CheckID'
         +  '^CheckDeductionCounter'
         +  '^DeductionType'
         +  '^DeductionDescription'
         +  '^DeductionAmount'
         +  '^TotalYearToDateDeductionAmount' AS 'line_output'
    UNION ALL
    SELECT RTRIM(HROrganization)
         + '^' + RTRIM(Employee)
         + '^' + CONVERT(varchar(10), EffectiveDate, 112)
         + '^' + CONVERT(varchar(10), CheckDate, 112)
         + '^' + RTRIM(CheckID)
         + '^' + CONVERT(varchar(10), CheckDeductionCounter)
         + '^' + DeductionType
         + '^' + RTRIM(DeductionDescription)
         + '^' + CONVERT(varchar(18),DeductionAmount,0)
         + '^' + CONVERT(varchar(18),YearToDateDeductionAmount,0) AS line_output
    FROM dbo.ghr_pay_check_deduction


END  -- End of SP

GO
ALTER AUTHORIZATION ON dbo.usp_pay_stmt_deduc_export TO SCHEMA OWNER
GO


IF OBJECT_ID(N'dbo.usp_pay_stmt_deduc_export', N'P') IS NOT NULL
    PRINT N'<<< CREATED PROCEDURE dbo.usp_pay_stmt_deduc_export >>>'
ELSE
    PRINT N'<<< FAILED CREATING PROCEDURE dbo.usp_pay_stmt_deduc_export >>>'
GO

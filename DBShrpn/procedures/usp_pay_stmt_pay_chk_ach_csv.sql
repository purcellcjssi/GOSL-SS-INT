USE DBShrpn
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID(N'dbo.usp_pay_stmt_pay_chk_ach_csv', N'P') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.usp_pay_stmt_pay_chk_ach_csv
    IF OBJECT_ID(N'dbo.usp_pay_stmt_pay_chk_ach_csv') IS NOT NULL
        PRINT N'<<< FAILED DROPPING PROCEDURE dbo.usp.usp_pay_stmt_pay_chk_ach_csv >>>'
    ELSE
        PRINT N'<<< DROPPED PROCEDURE dbo.usp_pay_stmt_pay_chk_ach_csv >>>'
END
GO

/*************************************************************************************

    SP Name:
        usp_pay_stmt_pay_chk_ach_csv

    Description:
        SmartStream to HCM Cloud Suite Pay Check Extract Interface



    Parameters:
        None

    Tables:
        DBShrpn.dbo.ghr_pay_check_ach


    Example:
         DBShrpn.dbo.usp_pay_stmt_pay_chk_ach_csv



   Revision history:
   version  date        developer   SCR         description
   -------  ----------  ---------   -----       ------------------------------------
   1.0.00   05/06/2026  CJP                     - Created procedure

************************************************************************************/
CREATE PROCEDURE dbo.usp_pay_stmt_pay_chk_ach_csv

AS

BEGIN

    SET NOCOUNT ON


    ---------------------------------------------------------------------------
    -- Export ACH Records
    ---------------------------------------------------------------------------
    SELECT 'EffectiveDate'      AS 'EffectiveDate'
         , 'HROrganization'     AS 'HROrganization'
         , 'Employee'           AS 'Employee'
         , 'CheckDate'          AS 'CheckDate'
         , 'CheckID'            AS 'CheckID'
         , 'CheckACHCounter'    AS 'CheckACHCounter'
         , 'ACHDescription'     AS 'ACHDescription'
         , 'DistributionAmount' AS 'DistributionAmount'
    UNION ALL
    SELECT CONVERT(varchar(10), EffectiveDate, 112)
         , HROrganization
         , Employee
         , CONVERT(varchar(10), CheckDate, 112)
         , CheckID
         , CONVERT(varchar(10), CheckACHCounter)
         , RTRIM(ACHDescription)
         , CONVERT(varchar(10), DistributionAmount, 0)
    FROM dbo.ghr_pay_check_ach


END  -- End of SP

GO
ALTER AUTHORIZATION ON dbo.usp_pay_stmt_pay_chk_ach_csv TO SCHEMA OWNER
GO


IF OBJECT_ID(N'dbo.usp_pay_stmt_pay_chk_ach_csv', N'P') IS NOT NULL
    PRINT N'<<< CREATED PROCEDURE dbo.usp_pay_stmt_pay_chk_ach_csv >>>'
ELSE
    PRINT N'<<< FAILED CREATING PROCEDURE dbo.usp_pay_stmt_pay_chk_ach_csv >>>'
GO

USE DBShrpn
GO

IF OBJECT_ID('dbo.ufn_ret_ganymede_to_hcm_emp_id') IS NOT NULL
BEGIN
    DROP FUNCTION dbo.ufn_ret_ganymede_to_hcm_emp_id
    IF OBJECT_ID('dbo.ufn_ret_ganymede_to_hcm_emp_id') IS NOT NULL
        PRINT '<<< FAILED DROPPING FUNCTION dbo.ufn_ret_ganymede_to_hcm_emp_id >>>'
    ELSE
        PRINT '<<< DROPPED FUNCTION dbo.ufn_ret_ganymede_to_hcm_emp_id >>>'
END
GO

/****************************************************************************************

  Function:     ufn_ret_ganymede_to_hcm_emp_id
  Author:       Chris Purcell

  Description:  Converts ganymede employee id to HCM employee id
                Ganymede employee ids are prefixed with 'D'
                where they are prefixed with '4'

  Parameters:   @p_file_source = 'SS VENUS' or 'SS GANYMEDE'
                @p_emp_id      = Employee ID


   Example:
      SELECT dbo.ufn_ret_ganymede_to_hcm_emp_id ('SS GANYMEDE','D3929')

   Revision history:
      version  date        developer   SCR      description
      -------  ----------  ---------   -----    ------------------------------------
      1.0.00   10/13/2025  CJP                  - Created function

****************************************************************************************/


CREATE FUNCTION dbo.ufn_ret_ganymede_to_hcm_emp_id
(
  @p_file_source    varchar(50)
, @p_emp_id         char(15)
)

RETURNS char(15)
AS
BEGIN

    DECLARE @v_emp_id  char(15) = ''

    IF (@p_file_source = 'SS GANYMEDE')
        IF (CHARINDEX('D', @p_emp_id, 1) = 1)
            SET @v_emp_id = STUFF(@p_emp_id, 1, 1, '4')
        ELSE
            SET @v_emp_id = @p_emp_id
    ELSE
        SET @v_emp_id = @p_emp_id


    RETURN @v_emp_id

END
GO

ALTER AUTHORIZATION ON dbo.ufn_ret_ganymede_to_hcm_emp_id TO  SCHEMA OWNER
GO

GRANT  REFERENCES ,  EXECUTE  ON dbo.ufn_ret_ganymede_to_hcm_emp_id  TO [public];
GO

IF OBJECT_ID('dbo.ufn_ret_ganymede_to_hcm_emp_id') IS NOT NULL
    PRINT '<<< CREATED FUNCTION dbo.ufn_ret_ganymede_to_hcm_emp_id >>>'
ELSE
    PRINT '<<< FAILED CREATING FUNCTION dbo.ufn_ret_ganymede_to_hcm_emp_id >>>'
GO
 
USE DBShrpn
GO

IF OBJECT_ID('dbo.ufn_ret_job_or_pos_id') IS NOT NULL
BEGIN
    DROP FUNCTION dbo.ufn_ret_job_or_pos_id
    IF OBJECT_ID('dbo.ufn_ret_job_or_pos_id') IS NOT NULL
        PRINT '<<< FAILED DROPPING FUNCTION dbo.ufn_ret_job_or_pos_id >>>'
    ELSE
        PRINT '<<< DROPPED FUNCTION dbo.ufn_ret_job_or_pos_id >>>'
END
GO

/****************************************************************************************

  Function:     ufn_ret_job_or_pos_id
  Author:       Chris Purcell
  Date:         9/15/2025

  Description:  Returns the job_or_pos_id based on file_source and associates employer id.

  Parameters:   @p_file_source  = 'SS VENUS' or 'SS GANYMEDE'
                @p_emp_id       = Ganymede Employee ID


   Example:
      SELECT dbo.ufn_ret_job_or_pos_id ('SS VENUS','WNE-00012')

   Revision history:
      version  date        developer   SCR      description
      -------  ----------  ---------   -----    ------------------------------------
      1.0.00   09/15/2025  CJP                  - Created function

****************************************************************************************/


CREATE FUNCTION dbo.ufn_ret_job_or_pos_id
(
  @p_file_source    varchar(50)
, @p_empl_id        char(10)
)

RETURNS char(10)
AS
BEGIN

    DECLARE @v_job_or_pos_id  char(10) = ''

    IF (@p_file_source = 'SS VENUS')
        IF (CHARINDEX('PEN', UPPER(@p_empl_id), 1) = 1)
            SET @v_job_or_pos_id = '99PEN-001'--'PEN-0001'
        ELSE
            SET @v_job_or_pos_id = '99GEN-001'--'GEN-0001'
    ELSE   -- Ganymede FORTHCM
        IF (@p_file_source = 'SS GANYMEDE')
            SET @v_job_or_pos_id = 'FORT001'


    RETURN @v_job_or_pos_id

END
GO

ALTER AUTHORIZATION ON dbo.ufn_ret_job_or_pos_id TO  SCHEMA OWNER
GO

GRANT  REFERENCES ,  EXECUTE  ON dbo.ufn_ret_job_or_pos_id  TO [public];
GO

IF OBJECT_ID('dbo.ufn_ret_job_or_pos_id') IS NOT NULL
    PRINT '<<< CREATED FUNCTION dbo.ufn_ret_job_or_pos_id >>>'
ELSE
    PRINT '<<< FAILED CREATING FUNCTION dbo.ufn_ret_job_or_pos_id >>>'
GO
 

USE DBShrpn
GO

IF OBJECT_ID('dbo.ufn_text_splitter') IS NOT NULL
BEGIN
    DROP FUNCTION dbo.ufn_text_splitter
    IF OBJECT_ID('dbo.ufn_text_splitter') IS NOT NULL
        PRINT '<<< FAILED DROPPING FUNCTION dbo.ufn_text_splitter >>>'
    ELSE
        PRINT '<<< DROPPED FUNCTION dbo.ufn_text_splitter >>>'
END
GO

/****************************************************************************************

   Function Name:    ufn_text_splitter

   Description:      This function will parse @p_string by the delimiter in @p_delimiter.
                     The results will be stored in @p_parsed which is a table data type.

                The built in limitations are:
                  1) The string length can't exceed 8000 characters
                  2) Parsed values can't exceed 255 characters

   Parameters:  @p_string    = Tilde delimited string of values (i.e. "100~200~3000")
                @p_delimiter = Character to delimit the string by (i.e. ~ or |)

   Example:
      SELECT val FROM ufn_text_splitter('100~200~3000', '~')

   Revision history:
      version  date        developer  description
      -------  ----------  ---------  ------------------------------------------------------------
      1.0.00   05/05/08    CJP        - Created function (originally created for eReports BSS.exe)
	    1.0.01   10/11/2011  CJP        - Removed hardcoded '~' from code and replaced with variable @p_delimiter
	    2.0.00   10/16/2026  CJP		    - Renamed func to ufn_text_splitter
										                    1) Needed in GOSL since they are still on SQL Server 2016

****************************************************************************************/

CREATE FUNCTION dbo.ufn_text_splitter
   (
    @p_string        varchar(8000),
    @p_delimiter     varchar(1)
   )
RETURNS @p_parsed TABLE
  (
   val varchar(255)
  )
AS
BEGIN

  -- Declare variables
  DECLARE @p_char varchar(1),
          @p_n int,
          @p_len int,
          @p_pos int,
          @p_val varchar(255)

  -- Initialize variables
  SET @p_n = 1
  SET @p_len = LEN(@p_string)
  SET @p_val = ''

  -- Parse @p_job_id_delim
  WHILE (@p_n <= @p_len)
    BEGIN
      SET @p_char = SUBSTRING(@p_string, @p_n, 1)

      IF (@p_char <> @p_delimiter)
        SET @p_val = @p_val + @p_char
      ELSE
        BEGIN
          INSERT INTO @p_parsed VALUES (@p_val)
          SET @p_val = ''
        END

      SET @p_n = @p_n + 1
    END

  -- Insert last value - don't insert a null
  IF (LEN(@p_val) > 0)
    INSERT INTO @p_parsed VALUES (@p_val)

  RETURN
END
go
SET ANSI_NULLS OFF
go
SET QUOTED_IDENTIFIER OFF
go

ALTER AUTHORIZATION ON dbo.ufn_text_splitter TO  SCHEMA OWNER
GO
GRANT REFERENCES ON dbo.ufn_text_splitter TO public
GO

IF OBJECT_ID('dbo.ufn_text_splitter') IS NOT NULL
    PRINT '<<< CREATED FUNCTION dbo.ufn_text_splitter >>>'
ELSE
    PRINT '<<< FAILED CREATING FUNCTION dbo.ufn_text_splitter >>>'
go

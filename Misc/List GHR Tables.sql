USE DBShrpn
GO


DECLARE @TableName NVARCHAR(256);
DECLARE @SchemaName NVARCHAR(256);
DECLARE @v_counter INT = 0;


-- Declare the cursor for all user-defined stored procedures
DECLARE crsrTables CURSOR FAST_FORWARD FOR
SELECT s.name AS SchemaName
     , t.name AS TableName
FROM sys.tables t
JOIN sys.schemas s ON
	(t.schema_id = s.schema_id)
WHERE (CHARINDEX('ghr', t.name, 1) = 1);


OPEN crsrTables;

FETCH NEXT FROM crsrTables
INTO @SchemaName
   , @TableName;

WHILE (@@FETCH_STATUS = 0)
BEGIN

    SET @v_counter = @v_counter + 1;

    -- Do something with each procedure, e.g., print the name
    PRINT CONVERT(NVARCHAR(10), @v_counter) + ': ' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@TableName);



    FETCH NEXT FROM crsrTables
    INTO @SchemaName
       , @TableName;
END

CLOSE crsrTables;
DEALLOCATE crsrTables;
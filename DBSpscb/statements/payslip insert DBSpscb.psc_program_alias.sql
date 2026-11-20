USE [DBSpscb]
GO

DECLARE @v_path	varchar(255);

DELETE FROM dbo.psc_program_alias
WHERE (psc_key IN ('RENAMEPAYSLIP', 'UPLOADPAYSLIP'))


IF (@@SERVERNAME = 'VENUSRD')
	SET @v_path = 'C:\FTP_DATA\EXEDEV\Batch\';
ELSE
	SET @v_path = 'C:\FTP_DATA\EXEPRD\Batch\';


INSERT [dbo].[psc_program_alias] ([psc_key], [psc_pgm_name], [psc_window_id], [psc_pgm_op_sys], [psc_dbs_prog_sw], [psc_owner], [psc_access], [chgstamp]) 
VALUES 
  (N'RENAMEPAYSLIP', @v_path + 'PayslipDateStamp.bat', N'', N'', 0, N'DBS', N'PUBLIC', 0)
, (N'UPLOADPAYSLIP', @v_path + 'UploadPayslip.bat', N'', N'', 0, N'DBS', N'PUBLIC', 0)

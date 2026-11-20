USE [DBSpiqd]
GO

DECLARE @v_path	varchar(255);

DELETE FROM dbo.piq_storedproc
WHERE (piq_request_name IN (
                            'USP_PAY_STMT_DEDUC_EXPORT'
						   ,'USP_PAY_STMT_EARN_EXPORT'
						   ,'USP_PAY_STMT_EXTRACT_MANUAL'
						   ,'USP_PAY_STMT_HDR_EXPORT'
						   ,'USP_PAY_STMT_EXTRACT_BATDISB'
						   ))


IF (@@SERVERNAME ='VENUSRD')
	SET @v_path ='C:\FTP_DATA\DATA\DEV\PaySlip\';
ELSE
	SET @v_path ='C:\FTP_DATA\DATA\PRD\PaySlip\';



INSERT [dbo].[piq_storedproc] ([piq_userid], [piq_request_name], [piq_server_name], [piq_db_name], [piq_proc_name], [piq_row_limit], [piq_answer_name], [piq_proc_parms], [piq_delimit_format], [chgstamp])
VALUES
(N'DBS', N'USP_PAY_STMT_DEDUC_EXPORT', @@SERVERNAME, N'DBShrpn', N'usp_pay_stmt_deduc_export', 0, @v_path + 'ViewEmployeePayCheckDeductionVenus', N'', N'T', 0)
,(N'DBS', N'USP_PAY_STMT_EARN_EXPORT', @@SERVERNAME, N'DBShrpn', N'usp_pay_stmt_earn_export', 0, @v_path + 'ViewEmployeePayCheckEarningVenus', N'', N'T', 0)
,(N'DBS', N'USP_PAY_STMT_EXTRACT_MANUAL', @@SERVERNAME, N'DBShrpn', N'usp_pay_stmt_main_extract', 0, N'', N'''M12Y2024''', N'C', 0)
,(N'DBS', N'USP_PAY_STMT_HDR_EXPORT', @@SERVERNAME, N'DBShrpn', N'usp_pay_stmt_hdr_export', 0, @v_path + 'ViewEmployeePayCheckVenus', N'', N'T', 0)
--,(N'DBS', N'USP_PAY_STMT_EXTRACT_BATDISB', @@SERVERNAME, N'DBShrpn', N'usp_pay_stmt_main_extract', 0, N'', N'', N'C', 0)
GO

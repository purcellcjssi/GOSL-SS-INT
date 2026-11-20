USE [DBSpscb]
GO

DELETE FROM dbo.psc_step
WHERE (psc_batchname = 'GHR')
  AND (psc_qualifier IN (
                         'PAYSLIP_INTERFACE_MANUAL'
                        ,'PAYSLIP_INTERFACE_BATDISB'
						))
GO


INSERT [dbo].[psc_step] ([psc_userid], [psc_batchname], [psc_qualifier], [psc_stepname], [psc_step_number], [psc_prev_step], [psc_next_step], [psc_ignore_step_sw], [psc_dbs_prog_sw], [psc_unique_id], [psc_class], [psc_priority], [psc_condx_test], [psc_condx_test_code], [psc_condx_next_step], [psc_last_updt_date], [psc_last_comp_date], [psc_last_comp_rc], [psc_pgm_name], [psc_pgm_parms], [chgstamp]) VALUES 
VALUES
  (N'DBS', N'GHR', N'PAYSLIP_INTERFACE_MANUAL', N'EXT', 1, N'', N'HDR', 0, 1, 0, N'WIN10CLS', 50, N'2', 0, N'END', CAST(N'2026-11-04 11:45:00.843' AS DateTime), CAST(N'2026-11-11 15:26:16.530' AS DateTime), 0, N'Connect Stored Procedure', N'USP_PAY_STMT_EXTRACT_MANUAL', 23)
, (N'DBS', N'GHR', N'PAYSLIP_INTERFACE_MANUAL', N'HDR', 2, N'EXT', N'EARN', 0, 1, 0, N'WIN10CLS', 50, N'2', 0, N'END', CAST(N'2026-11-04 11:28:10.103' AS DateTime), CAST(N'2026-11-11 15:26:26.600' AS DateTime), 0, N'Connect Stored Procedure', N'USP_PAY_STMT_HDR_EXPORT', 22)
, (N'DBS', N'GHR', N'PAYSLIP_INTERFACE_MANUAL', N'EARN', 3, N'HDR', N'DEDUC', 0, 1, 0, N'WIN10CLS', 50, N'2', 0, N'END', CAST(N'2026-11-04 11:28:10.180' AS DateTime), CAST(N'2026-11-11 15:26:36.667' AS DateTime), 0, N'Connect Stored Procedure', N'USP_PAY_STMT_EARN_EXPORT', 22)
, (N'DBS', N'GHR', N'PAYSLIP_INTERFACE_MANUAL', N'DEDUC', 4, N'EARN', N'RENAME', 0, 1, 0, N'WIN10CLS', 50, N'2', 0, N'END', CAST(N'2026-11-04 11:28:10.267' AS DateTime), CAST(N'2026-11-11 15:26:46.747' AS DateTime), 0, N'Connect Stored Procedure', N'USP_PAY_STMT_DEDUC_EXPORT', 22)
, (N'DBS', N'GHR', N'PAYSLIP_INTERFACE_MANUAL', N'RENAME', 5, N'DEDUC', N'UPLOAD', 0, 0, 0, N'WIN10CLS', 50, N'', 0, N'', CAST(N'2026-11-04 11:28:10.333' AS DateTime), CAST(N'2026-11-11 15:27:06.837' AS DateTime), 0, N'RENAMEPAYSLIP', N'', 22)
, (N'DBS', N'GHR', N'PAYSLIP_INTERFACE_MANUAL', N'UPLOAD', 6, N'RENAME', N'END', 0, 0, 0, N'WIN10CLS', 50, N'', 0, N'', CAST(N'2026-11-04 11:28:10.413' AS DateTime), CAST(N'2026-11-11 15:27:47.010' AS DateTime), 0, N'UPLOADPAYSLIP', N'', 22)
, (N'DBS', N'GHR', N'PAYSLIP_INTERFACE_MANUAL', N'END', 7, N'UPLOAD', N'', 0, 1, 0, N'WIN10CLS', 50, N'', 0, N'', CAST(N'2026-11-04 11:28:10.473' AS DateTime), CAST(N'1900-01-01 00:00:00.000' AS DateTime), 0, N'STOP', N'', 0)
/*
, (N'DBS', N'GHR', N'PAYSLIP_INTERFACE_BATDISB', N'EXT', 1, N'', N'HDR', 0, 1, 0, N'WIN10CLS', 50, N'2', 0, N'END', CAST(N'2026-11-03 11:29:38.480' AS DateTime), CAST(N'1900-01-01 00:00:00.000' AS DateTime), 0, N'Connect Stored Procedure', N'USP_PAY_STMT_EXTRACT_BATDISB', 1)
, (N'DBS', N'GHR', N'PAYSLIP_INTERFACE_BATDISB', N'HDR', 2, N'EXT', N'EARN', 0, 1, 0, N'WIN10CLS', 50, N'2', 0, N'END', CAST(N'2026-11-03 11:29:21.427' AS DateTime), CAST(N'1900-01-01 00:00:00.000' AS DateTime), 0, N'Connect Stored Procedure', N'USP_PAY_STMT_HDR_EXPORT', 0)
, (N'DBS', N'GHR', N'PAYSLIP_INTERFACE_BATDISB', N'EARN', 3, N'HDR', N'DEDUC', 0, 1, 0, N'WIN10CLS', 50, N'2', 0, N'END', CAST(N'2026-11-03 11:29:21.497' AS DateTime), CAST(N'1900-01-01 00:00:00.000' AS DateTime), 0, N'Connect Stored Procedure', N'USP_PAY_STMT_EARN_EXPORT', 0)
, (N'DBS', N'GHR', N'PAYSLIP_INTERFACE_BATDISB', N'DEDUC', 4, N'EARN', N'RENAME', 0, 1, 0, N'WIN10CLS', 50, N'2', 0, N'END', CAST(N'2026-11-03 11:29:21.557' AS DateTime), CAST(N'1900-01-01 00:00:00.000' AS DateTime), 0, N'Connect Stored Procedure', N'USP_PAY_STMT_DEDUC_EXPORT', 0)
, (N'DBS', N'GHR', N'PAYSLIP_INTERFACE_BATDISB', N'RENAME', 5, N'DEDUC', N'UPLOAD', 0, 0, 0, N'WIN10CLS', 50, N'2', 0, N'END', CAST(N'2026-11-03 11:29:21.613' AS DateTime), CAST(N'1900-01-01 00:00:00.000' AS DateTime), 0, N'RENAMEPAYSLIP', N'', 0)
, (N'DBS', N'GHR', N'PAYSLIP_INTERFACE_BATDISB', N'UPLOAD', 6, N'RENAME', N'END', 0, 1, 0, N'WIN10CLS', 50, N'2', 0, N'END', CAST(N'2026-11-03 11:29:50.357' AS DateTime), CAST(N'1900-01-01 00:00:00.000' AS DateTime), 0, N'UPLOADPAYSLIP', N'', 1)
, (N'DBS', N'GHR', N'PAYSLIP_INTERFACE_BATDISB', N'END', 7, N'UPLOAD', N'', 0, 1, 0, N'WIN10CLS', 50, N'', 0, N'', CAST(N'2026-11-03 11:29:21.737' AS DateTime), CAST(N'1900-01-01 00:00:00.000' AS DateTime), 0, N'STOP', N'', 0)
*/

GO

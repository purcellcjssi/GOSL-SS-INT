USE [DBSpscb]
GO


DELETE FROM dbo.psc_batch
WHERE (psc_batchname = 'GHR')
  AND (psc_qualifier IN (
                         'PAYSLIP_INTERFACE_MANUAL'
                        ,'PAYSLIP_INTERFACE_BATDISB'
						))


INSERT [dbo].[psc_batch] ([psc_userid], [psc_batchname], [psc_qualifier], [psc_batchtype], [psc_description], [psc_security_profile], [psc_interval_spec], [psc_nxt_run_date], [psc_last_run_date], [psc_last_updt_date], [psc_last_comp_date], [psc_last_comp_rc], [psc_last_low_rc], [psc_lang_code], [psc_lang_code_dialect], [psc_status], [psc_first_step], [psc_last_step], [psc_distribution_id], [psc_dist_status], [psc_dist_condx_test], [psc_dist_condx_code], [psc_run_now], [psc_last_run_now], [psc_abort_flag], [psc_del_on_end], [psc_public], [psc_read_only], [psc_event_name], [psc_first_run_date], [chgstamp]) 
VALUES 
 (N'DBS', N'GHR', N'PAYSLIP_INTERFACE_MANUAL', N'I', N'Pay Slip Interface to the Global HR', N'DBS', N'', CAST(N'2999-12-31 00:00:00.000' AS DateTime), CAST(N'2999-12-31 23:59:59.000' AS DateTime), CAST(N'2026-11-11 15:25:50.213' AS DateTime), CAST(N'2026-11-11 15:27:47.037' AS DateTime), 0, 0, N'EN', N'', N'', N'EXT', N'END', N'TO:cpurcell@smartsi.com + SMTP:cpurcell@smartsi.com; TO:cdavis@smartsi.com + SMTP:cdavis@smartsi.com', N'A', N'', 0, N'N', N'Y', N'N', N'N', N'N', N'N', N'', CAST(N'1900-01-01 00:00:00.000' AS DateTime), 0)
--, (N'DBS', N'GHR', N'PAYSLIP_INTERFACE_BATDISB', N'I', N'Pay Slip Interface to the Global HR', N'DBS', N'', CAST(N'2999-12-31 00:00:00.000' AS DateTime), CAST(N'2999-12-31 23:59:59.000' AS DateTime), CAST(N'2026-11-03 11:29:50.270' AS DateTime), CAST(N'1900-01-01 00:00:00.000' AS DateTime), 0, 0, N'EN', N'', N'', N'EXT', N'END', N'TO:cpurcell@smartsi.com + SMTP:cpurcell@smartsi.com', N'A', N'', 0, N'N', N'Y', N'N', N'N', N'N', N'N', N'', CAST(N'1900-01-01 00:00:00.000' AS DateTime), 0)

GO

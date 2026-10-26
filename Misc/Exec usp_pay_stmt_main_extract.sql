/*
DELETE FROM DBShrpn.dbo.ghr_pay_check
GO
*/

EXEC DBShrpn.dbo.usp_pay_stmt_main_extract
              @p_payroll_run_ctrl_id = 'M5Y2026'
            , @p_pmt_meth_id         = 'DDPST'
            , @p_emp_id              = '17201~17202~17203'
go

select * from DBShrpn.dbo.ghr_pay_check
go

select * from DBShrpn.dbo.ghr_pay_check_earning
go

select * from DBShrpn.dbo.ghr_pay_check_deduction
go

/*
DELETE FROM DBShrpn.dbo.ghr_pay_check
GO
*/

EXEC DBShrpn.dbo.usp_pay_stmt_main_extract

go

select * from DBShrpn.dbo.ghr_pay_check
go

select * from DBShrpn.dbo.ghr_pay_check_earning
go

select * from DBShrpn.dbo.ghr_pay_check_deduction
go

select *
from DBShrpn..emp_status
where emp_id = '21508'
go

select *
from DBShrpn..emp_employment
where emp_id = '21508'
go


/*
delete DBShrpn..emp_status
where emp_id = '21508'
and status_change_date = '2026-05-16'
go

update DBShrpn..emp_status
set next_change_date = '2999-12-31'
where emp_id = '21508'
and status_change_date = '2025-07-31'
go


delete DBShrpn..emp_employment
where emp_id = '21508'
and eff_date = '2026-05-16'
go

update DBShrpn..emp_employment
set next_eff_date = '2999-12-31'
where emp_id = '21508'
and eff_date = '2024-09-02'
go

*/

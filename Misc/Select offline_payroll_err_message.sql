select *
from DBShrpy.dbo.offline_payroll_err_message
WHERE err_message_id IN ('hpy0002004', 'hpy0001885')
ORDER BY process_start_date_and_tm DESC

SELECT err1.*
FROM DBShrpy.dbo.offline_payroll_err_message err1
WHERE (err1.process_id = 'BATCOMP')
  AND (err1.process_start_date_and_tm = (
                                         SELECT MAX(err2.process_start_date_and_tm)
										 FROM DBShrpy.dbo.offline_payroll_err_message err2
										 WHERE (err2.process_id = err1.process_id)
                                        ))
ORDER BY err1.seq_nbr

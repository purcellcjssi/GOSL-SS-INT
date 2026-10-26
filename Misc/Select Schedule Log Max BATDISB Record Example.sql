SELECT *
   ,  REVERSE(PARSENAME(REPLACE(REVERSE(psc_pgm_parms), ' ', '.'), 1)) AS run_ctrl_id
   , REVERSE(PARSENAME(REPLACE(REVERSE(psc_pgm_parms), ' ', '.'), 2)) AS pmt_meth_id
FROM [DBSpscb].[dbo].[psc_log] pl1
where psc_batchname = 'BATDISB'
  and psc_unique_id = (
                       SELECT MAX(pl2.psc_unique_id)
					   FROM [DBSpscb].[dbo].[psc_log] pl2
					   WHERE (pl2.psc_batchname = pl1.psc_batchname)
					     AND (pl2.psc_endtime = (
                                                 SELECT MAX(pl3.psc_endtime)
												 FROM [DBSpscb].[dbo].[psc_log] pl3
												 WHERE (pl3.psc_batchname = pl1.psc_batchname)
												   AND (pl3.psc_endtime < '2026-05-28 08:00:00.000')
												))
					  )
--and psc_unique_id = 109903
GO


select *
from DBShrpy.dbo.offline_payroll_err_message
WHERE err_message_id IN ('hpy0002004', 'hpy0001885')
and run_id_1 = 'DPM4Y2026'

ORDER BY process_start_date_and_tm DESC
GO
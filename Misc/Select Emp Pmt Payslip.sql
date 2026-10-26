select dsb.pmt_meth_id
     , pmt.*

FROM DBShrpy.dbo.emp_pmt pmt WITH (NOLOCK)
JOIN DBShrpy.dbo.emp_pmt_disbursal_detail dsb WITH (NOLOCK) ON
    (pmt.emp_id              = dsb.emp_id) AND
    (pmt.payroll_run_type_id = dsb.payroll_run_type_id) AND
    (pmt.pay_pd_id           = dsb.pay_pd_id) AND
    (pmt.pmt_seq_nbr         = dsb.pmt_seq_nbr)

where 1=1
  and pmt.procsd_by_payroll_run_ctrl_id = 'M6Y2026T2'
  and dsb.pmt_meth_id = 'DDPST'
  --and pmt.seq_ctrl_yr = 2026
  --AND pmt.payroll_run_type_id = 'MONTHLY'
  --and pmt.pay_pd_id = '6 2026'
  --and pmt.emp_id = '10236'

order by check_date desc

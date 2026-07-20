USE DBShrpn
GO


IF OBJECT_ID('dbo.uvu_emp_assignment_most_rec') IS NOT NULL
BEGIN
    DROP VIEW dbo.uvu_emp_assignment_most_rec
    IF OBJECT_ID('dbo.uvu_emp_assignment_most_rec') IS NOT NULL
        PRINT '<<< FAILED DROPPING VIEW dbo.uvu_emp_assignment_most_rec >>>'
    ELSE
        PRINT '<<< DROPPED VIEW dbo.uvu_emp_assignment_most_rec >>>'
END
GO

/****************************************************************************************

   View Name:     uvu_emp_assignment_most_rec

   Description:   Used to obtain the most recent employee assignment information.

   Table_Name(s):   INPUT:    DBShrpn..emp_assignemnt

   Revision history:
      version  date        developer   description
      -------  ----------  ---------   --------------------------------------------------
      1.0.00   08/06/2025  cjp         - Created view

****************************************************************************************/

CREATE VIEW dbo.uvu_emp_assignment_most_rec

AS

SELECT ea.emp_id
     , ea.assigned_to_code
     , ea.job_or_pos_id
     , ea.eff_date
     , ea.next_eff_date
     , ea.prior_eff_date
     , ea.next_assigned_to_code
     , ea.next_job_or_pos_id
     , ea.prior_assigned_to_code
     , ea.prior_job_or_pos_id
     , ea.begin_date
     , ea.end_date
     , ea.assignment_reason_code
     , ea.organization_chart_name
     , ea.organization_unit_name
     , ea.organization_group_id
     , ea.organization_change_reason_cd
     , ea.loc_code
     , ea.mgr_emp_id
     , ea.official_title_code
     , ea.official_title_date
     , ea.salary_change_date
     , ea.annual_salary_amt
     , ea.pd_salary_amt
     , ea.pd_salary_tm_pd_id
     , ea.hourly_pay_rate
     , ea.curr_code
     , ea.pay_on_reported_hrs_ind
     , ea.salary_change_type_code
     , ea.standard_work_pd_id
     , ea.standard_work_hrs
     , ea.work_tm_code
     , ea.work_shift_code
     , ea.salary_structure_id
     , ea.salary_increase_guideline_id
     , ea.pay_grade_code
     , ea.pay_grade_date
     , ea.job_evaluation_points_nbr
     , ea.salary_step_nbr
     , ea.salary_step_date
     , ea.phone_1_type_code
     , ea.phone_1_fmt_code
     , ea.phone_1_fmt_delimiter
     , ea.phone_1_intl_code
     , ea.phone_1_country_code
     , ea.phone_1_area_city_code
     , ea.phone_1_nbr
     , ea.phone_1_extension_nbr
     , ea.phone_2_type_code
     , ea.phone_2_fmt_code
     , ea.phone_2_fmt_delimiter
     , ea.phone_2_intl_code
     , ea.phone_2_country_code
     , ea.phone_2_area_city_code
     , ea.phone_2_nbr
     , ea.phone_2_extension_nbr
     , ea.prime_assignment_ind
     , ea.pay_basis_code
     , ea.occupancy_code
     , ea.regulatory_reporting_unit_code
     , ea.base_rate_tbl_id
     , ea.base_rate_tbl_entry_code
     , ea.shift_differential_rate_tbl_id
     , ea.ref_annual_salary_amt
     , ea.ref_pd_salary_amt
     , ea.ref_pd_salary_tm_pd_id
     , ea.ref_hourly_pay_rate
     , ea.guaranteed_annual_salary_amt
     , ea.guaranteed_pd_salary_amt
     , ea.guaranteed_pd_salary_tm_pd_id
     , ea.guaranteed_hourly_pay_rate
     , ea.exception_rate_ind
     , ea.overtime_status_code
     , ea.shift_differential_status_code
     , ea.standard_daily_work_hrs
     , ea.user_amt_1
     , ea.user_amt_2
     , ea.user_code_1
     , ea.user_code_2
     , ea.user_date_1
     , ea.user_date_2
     , ea.user_ind_1
     , ea.user_ind_2
     , ea.user_monetary_amt_1
     , ea.user_monetary_amt_2
     , ea.user_monetary_curr_code
     , ea.user_text_1
     , ea.user_text_2
     , ea.unemployment_loc_code
     , ea.include_salary_in_autopay_ind
     , ea.chgstamp
FROM DBShrpn.dbo.emp_assignment ea
WHERE (ea.next_eff_date = '12/31/2999')
  AND (ea.prime_assignment_ind = 'Y')
  AND (ea.end_date = (
                      SELECT MAX(ea2.end_date)
                      FROM DBShrpn..emp_assignment ea2
                      WHERE (ea2.emp_id               = ea.emp_id)
                        AND (ea2.prime_assignment_ind = ea.prime_assignment_ind)
                        AND (ea2.next_eff_date        = ea.next_eff_date)
                     ))
GO

ALTER AUTHORIZATION ON dbo.uvu_emp_assignment_most_rec TO  SCHEMA OWNER
GO


IF OBJECT_ID('dbo.uvu_emp_assignment_most_rec') IS NOT NULL
    PRINT '<<< CREATED VIEW dbo.uvu_emp_assignment_most_rec >>>'
ELSE
    PRINT '<<< FAILED CREATING VIEW dbo.uvu_emp_assignment_most_rec >>>'
GO
 
USE DBShrpn
GO


IF OBJECT_ID('dbo.uvu_emp_employment_most_rec') IS NOT NULL
BEGIN
    DROP VIEW dbo.uvu_emp_employment_most_rec
    IF OBJECT_ID('dbo.uvu_emp_employment_most_rec') IS NOT NULL
        PRINT '<<< FAILED DROPPING VIEW dbo.uvu_emp_employment_most_rec >>>'
    ELSE
        PRINT '<<< DROPPED VIEW dbo.uvu_emp_employment_most_rec >>>'
END
GO

/****************************************************************************************

   View Name:     uvu_emp_employment_most_rec

   Description:   Used to obtain the most recent employee assignment information.

   Table_Name(s):   INPUT:    DBShrpn..emp_employment

   Revision history:
      version  date        developer   description
      -------  ----------  ---------   --------------------------------------------------
      1.0.00   08/06/2025  cjp         - Created view

****************************************************************************************/

CREATE VIEW dbo.uvu_emp_employment_most_rec

AS

SELECT emp_id
     , eff_date
     , next_eff_date
     , prior_eff_date
     , employment_type_code
     , work_tm_code
     , official_title_code
     , official_title_date
     , mgr_ind
     , recruiter_ind
     , pensioner_indicator
     , payroll_company_code
     , pmt_ctrl_code
     , us_federal_tax_meth_code
     , us_federal_tax_amt
     , us_federal_tax_pct
     , us_federal_marital_status_code
     , us_federal_exemp_nbr
     , us_work_st_code
     , canadian_work_province_code
     , ipp_payroll_id
     , ipp_max_pay_level_amt
     , pay_through_date
     , empl_id
     , tax_entity_id
     , pay_status_code
     , clock_nbr
     , provided_i_9_ind
     , time_reporting_meth_code
     , regular_hrs_tracked_code
     , pay_element_ctrl_grp_id
     , pay_group_id
     , us_pension_ind
     , professional_cat_code
     , corporate_officer_ind
     , prim_disbursal_loc_code
     , alternate_disbursal_loc_code
     , labor_grp_code
     , employment_info_chg_reason_cd
     , highly_compensated_emp_ind
     , nbr_of_dependent_children
     , canadian_federal_tax_meth_cd
     , canadian_federal_tax_amt
     , canadian_federal_tax_pct
     , canadian_federal_claim_amt
     , canadian_province_claim_amt
     , tax_unit_code
     , requires_tm_card_ind
     , xfer_type_code
     , tax_clear_code
     , pay_type_code
     , labor_distn_code
     , labor_distn_ext_code
     , us_fui_status_code
     , us_fica_status_code
     , payable_through_bank_id
     , disbursal_seq_nbr_1
     , disbursal_seq_nbr_2
     , non_employee_indicator
     , excluded_from_payroll_ind
     , emp_info_source_code
     , user_amt_1
     , user_amt_2
     , user_monetary_amt_1
     , user_monetary_amt_2
     , user_monetary_curr_code
     , user_code_1
     , user_code_2
     , user_date_1
     , user_date_2
     , user_ind_1
     , user_ind_2
     , user_text_1
     , user_text_2
     , t4_employ_code
     , chgstamp
FROM   DBShrpn.dbo.emp_employment
WHERE  (next_eff_date = '12/31/2999')

GO

ALTER AUTHORIZATION ON dbo.uvu_emp_employment_most_rec TO  SCHEMA OWNER
GO


IF OBJECT_ID('dbo.uvu_emp_employment_most_rec') IS NOT NULL
    PRINT '<<< CREATED VIEW dbo.uvu_emp_employment_most_rec >>>'
ELSE
    PRINT '<<< FAILED CREATING VIEW dbo.uvu_emp_employment_most_rec >>>'
GO
 
USE DBShrpn
GO


IF OBJECT_ID('dbo.uvu_emp_status_most_rec') IS NOT NULL
BEGIN
    DROP VIEW dbo.uvu_emp_status_most_rec
    IF OBJECT_ID('dbo.uvu_emp_status_most_rec') IS NOT NULL
        PRINT '<<< FAILED DROPPING VIEW dbo.uvu_emp_status_most_rec >>>'
    ELSE
        PRINT '<<< DROPPED VIEW dbo.uvu_emp_status_most_rec >>>'
END
GO

/****************************************************************************************

   View Name:     uvu_emp_status_most_rec

   Description:   Used to obtain the most recent employee assignment information.

   Table_Name(s):   INPUT:    DBShrpn..emp_status

   Revision history:
      version  date        developer   description
      -------  ----------  ---------   --------------------------------------------------
      1.0.00   08/06/2025  cjp         - Created view

****************************************************************************************/

CREATE VIEW dbo.uvu_emp_status_most_rec

AS

SELECT stat1.emp_id
     , stat1.status_change_date
     , stat1.prior_change_date
     , stat1.next_change_date
     , stat1.emp_status_code
     , stat1.emp_status_classn_code
     , stat1.inactive_reason_code
     , stat1.hire_date
     , stat1.loa_expected_return_date
     , stat1.consider_for_rehire_ind
     , stat1.active_reason_code
     , stat1.termination_reason_code
     , stat1.last_action_code
     , stat1.chgstamp
FROM DBShrpn.dbo.emp_status stat1
WHERE (stat1.next_change_date = '12/31/2999')
  AND (stat1.status_change_date = (
                                    SELECT MAX(stat2.status_change_date)
                                    FROM DBShrpn..emp_status stat2
                                    WHERE (stat2.emp_id           = stat1.emp_id)
                                      AND (stat2.next_change_date = stat1.next_change_date)
                                   ))

GO

ALTER AUTHORIZATION ON dbo.uvu_emp_status_most_rec TO  SCHEMA OWNER
GO


IF OBJECT_ID('dbo.uvu_emp_status_most_rec') IS NOT NULL
    PRINT '<<< CREATED VIEW dbo.uvu_emp_status_most_rec >>>'
ELSE
    PRINT '<<< FAILED CREATING VIEW dbo.uvu_emp_status_most_rec >>>'
GO
 

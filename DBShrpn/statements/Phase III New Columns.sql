USE DBShrpn
GO

BEGIN


    -- Backup data with new column
    SELECT    t.event_id
            , t.emp_id
            , t.eff_date
            , t.first_name
            , t.first_middle_name
            , t.last_name
            , t.empl_id
            , t.national_id_type_code
            , t.national_id
            , t.organization_group_id
            , t.organization_chart_name
            , t.organization_unit_name
            , t.emp_status_classn_code
            , t.position_title
            , t.employment_type_code
            , t.annual_salary_amt
            , t.begin_date
            , t.end_date
            , t.pay_status_code
            , t.pay_group_id
            , t.pay_element_ctrl_grp_id
            , t.time_reporting_meth_code
            , t.employment_info_chg_reason_cd
            , t.emp_location_code
            , t.emp_status_code
            , t.reason_code
            , t.emp_expected_return_date
            , t.pay_through_date
            , t.emp_death_date
            , t.consider_for_rehire_ind
            , t.pay_element_id
            , t.emp_calculation
            , t.tax_flag
            , t.nic_flag
            , t.tax_ceiling_amt
            , t.labor_grp_code
            , t.file_source
            , t.annual_hrs_per_fte
            , t.annual_rate
            , t.birth_date
            , t.gender
            , t.addr_fmt_code
            , t.country_code
            , t.addr_line_1
            , t.addr_line_2
            , t.addr_line_3
            , t.addr_line_4
            , t.city_name
            , t.state_prov
            , t.postal_code
            , t.county_name
            , t.region_name
            , '' AS pay_rate_type_code
            , t.job_or_pos_id
            , t.activity_date
            , t.aud_id
            , t.activity_user
            , t.proc_flag
    INTO dbo.zz_ghr_employee_events_aud
    FROM dbo.ghr_employee_events_aud t

    -- Confirm that data was backed up successfully
    -- Run create table script


    -- Re-populate audit table with new column
    INSERT INTO dbo.ghr_employee_events_aud
    SELECT    t.event_id
            , t.emp_id
            , t.eff_date
            , t.first_name
            , t.first_middle_name
            , t.last_name
            , t.empl_id
            , t.national_id_type_code
            , t.national_id
            , t.organization_group_id
            , t.organization_chart_name
            , t.organization_unit_name
            , t.emp_status_classn_code
            , t.position_title
            , t.employment_type_code
            , t.annual_salary_amt
            , t.begin_date
            , t.end_date
            , t.pay_status_code
            , t.pay_group_id
            , t.pay_element_ctrl_grp_id
            , t.time_reporting_meth_code
            , t.employment_info_chg_reason_cd
            , t.emp_location_code
            , t.emp_status_code
            , t.reason_code
            , t.emp_expected_return_date
            , t.pay_through_date
            , t.emp_death_date
            , t.consider_for_rehire_ind
            , t.pay_element_id
            , t.emp_calculation
            , t.tax_flag
            , t.nic_flag
            , t.tax_ceiling_amt
            , t.labor_grp_code
            , t.file_source
            , t.annual_hrs_per_fte
            , t.annual_rate
            , t.birth_date
            , t.gender
            , t.addr_fmt_code
            , t.country_code
            , t.addr_line_1
            , t.addr_line_2
            , t.addr_line_3
            , t.addr_line_4
            , t.city_name
            , t.state_prov
            , t.postal_code
            , t.county_name
            , t.region_name
            , t.pay_rate_type_code
            , t.job_or_pos_id
            , t.activity_date
            , t.aud_id
            , t.activity_user
            , t.proc_flag
    FROM #tbl_temp_ghr_employee_events_aud t

    /*
    -- Drop backup table after confirming data is good
    DROP TABLE dbo.zz_ghr_employee_events_aud
    */


END
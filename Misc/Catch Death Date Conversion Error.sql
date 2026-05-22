USE DBShrpn
GO

BEGIN

	set nocount on


    DECLARE @v_END_OF_TIME_DATE             datetime            = '29991231'
    DECLARE @v_BAD_DATE_INDICATOR           datetime            = '99991231'    -- value used to populate datetime column with value from HCM that is not a valid date after conversion
    DECLARE @v_EMPTY_SPACE                  char(01)            = ''

    DECLARE @ErrorNumber                    varchar(10)
    DECLARE @ErrorMessage                   nvarchar(4000)
    DECLARE @ErrorSeverity                  int
    DECLARE @ErrorState                     int
    DECLARE @v_ret_val                      int                 = 0
    DECLARE @v_msg                          varchar(255)        = @v_EMPTY_SPACE


    CREATE TABLE #ghr_employee_events_temp
    (
      aud_id                                int	IDENTITY(1,1)   NOT NULL
    , event_id                              char(02)            NULL
    , emp_id                                char(15)            NULL
    , eff_date                              datetime            NULL    --char(10)            NULL
    , first_name                            char(25)            NULL
    , first_middle_name                     char(25)            NULL
    , last_name                             char(30)            NULL
    , empl_id                               char(10)            NULL
    , national_id_type_code                 char(05)            NULL
    , national_id                           char(20)            NULL
    , organization_group_id                 int                 NOT NULL
    , organization_chart_name               varchar(64)         NULL
    , organization_unit_name                varchar(240)        NULL
    , emp_status_classn_code                char(02)            NULL
    , position_title                        char(50)            NULL    -- DBShrpn..emp_assignment.user_text_2
    , employment_type_code                  varchar(70)         NULL    -- increased size to 70 from 5
    , annual_salary_amt                     money               NULL    --char(15)            NULL
    , begin_date                            datetime            NULL    --char(10)            NULL
    , end_date                              datetime            NULL    --char(10)            NULL
    , pay_status_code                       char(01)            NULL
    , pay_group_id                          char(10)            NULL
    , pay_element_ctrl_grp_id               char(10)            NULL
    , time_reporting_meth_code              char(01)            NULL
    , employment_info_chg_reason_cd         char(05)            NULL
    , emp_location_code                     char(10)            NULL
    , emp_status_code                       char(02)            NULL
    , reason_code                           char(02)            NULL
    , emp_expected_return_date              char(10)            NULL
    , pay_through_date                      datetime            NULL    --char(10)            NULL
    , emp_death_date                        datetime            NULL    --char(10)            NULL
    , consider_for_rehire_ind               char(01)            NULL
    , pay_element_id                        char(10)            NULL
    , emp_calculation                       money               NULL    --char(15)            NULL
    , tax_flag                              char(1)             NULL    -- individual_personal.user_ind_2
    , nic_flag                              char(1)             NULL    -- individual_personal.user_ind_1
    , tax_ceiling_amt                       char(15)            NULL    -- employee.user_monetary_amt_1
    , labor_grp_code                        char(50)            NULL    -- DBShrpn..emp_employment.labor_grp_code   char(5)
    , file_source                           char(50)            NULL    -- 'SS VENUS' or 'SS GANYMEDE'
    , annual_hrs_per_fte                    money               NULL    --varchar(255)        NULL
    , annual_rate                           money               NULL    --varchar(255)        NULL
    , birth_date                            datetime            NULL    --varchar(255)        NULL
    , gender                                char(01)        NULL
    , addr_fmt_code                         char(06)            NULL
    , country_code                          char(02)        NULL
    , addr_line_1                           varchar(35)        NULL
    , addr_line_2                           varchar(35)        NULL
    , addr_line_3                           varchar(35)        NULL
    , addr_line_4                           varchar(35)        NULL
    , city_name                             varchar(35)        NULL
    , state_prov                            char(09)        NULL
    , postal_code                           char(09)        NULL
    , county_name                           varchar(255)        NULL
    , region_name                           varchar(255)        NULL
    , job_or_pos_id                         char(10)            NULL    -- derived value based on file_source
    )

	BEGIN TRY

		select *
		from dbo.ghr_employee_events


        --INSERT INTO #ghr_employee_events_temp
        SELECT LEFT(t.event_id, 2) AS event_id
            , LEFT(t.emp_id, 15) AS emp_id
            , CASE
                WHEN (RTRIM(t.eff_date) = @v_BAD_DATE_INDICATOR) THEN @v_END_OF_TIME_DATE
                WHEN LEN(RTRIM(t.eff_date)) < 8 THEN @v_BAD_DATE_INDICATOR
                ELSE COALESCE(TRY_CONVERT(datetime, t.eff_date), @v_BAD_DATE_INDICATOR)
              END AS eff_date
            , LEFT(t.first_name, 25) AS first_name
            , LEFT(t.first_middle_name, 25) AS first_middle_name
            , LEFT(t.last_name, 25) AS last_name
            , UPPER(LEFT(t.empl_id, 15)) AS empl_id
            , LEFT(t.national_id_type_code, 5) AS national_id_type_code
            , LEFT(t.national_id, 20) AS national_id
            , COALESCE(TRY_CONVERT(int, t.organization_group_id), 0) AS organization_group_id
            , @v_EMPTY_SPACE AS organization_chart_name     -- t.organization_chart_name  -- wrong value
            , @v_EMPTY_SPACE AS organization_unit_name      -- t.organization_unit_name
            , LEFT(t.emp_status_classn_code, 2) AS emp_status_classn_code
            , LEFT(t.position_title, 50) AS position_title    -- trim value since HCM sends it over as char(60)
            , LEFT(UPPER(t.employment_type_code), 70) AS employment_type_code
            , COALESCE(TRY_CONVERT(money, t.annual_salary_amt), 0.00) AS annual_salary_amt
            , CASE
                WHEN (RTRIM(t.begin_date) = @v_BAD_DATE_INDICATOR) THEN @v_END_OF_TIME_DATE
                WHEN LEN(RTRIM(t.begin_date)) < 8 THEN @v_BAD_DATE_INDICATOR
                ELSE COALESCE(TRY_CONVERT(datetime, t.begin_date), @v_BAD_DATE_INDICATOR)
                END AS begin_date
            , CASE
                WHEN (RTRIM(t.end_date) = @v_BAD_DATE_INDICATOR) THEN @v_END_OF_TIME_DATE
                WHEN LEN(RTRIM(t.end_date)) < 8 THEN @v_BAD_DATE_INDICATOR
                ELSE COALESCE(TRY_CONVERT(datetime, t.end_date), @v_BAD_DATE_INDICATOR)
                END AS end_date
            , LEFT(t.pay_status_code, 1) AS pay_status_code
            , UPPER(LEFT(t.pay_group_id, 10)) AS pay_group_id
            , LEFT(t.pay_element_ctrl_grp_id, 10) AS pay_element_ctrl_grp_id
            , LEFT(t.time_reporting_meth_code, 1) AS time_reporting_meth_code
            , LEFT(t.employment_info_chg_reason_cd, 5) AS employment_info_chg_reason_cd
            , LEFT(t.emp_location_code, 10) AS emp_location_code
            , LEFT(t.emp_status_code, 2) AS emp_status_code
            , LEFT(t.reason_code, 5) AS reason_code
            , t.emp_expected_return_date
            , CASE
                WHEN (RTRIM(t.pay_through_date) = @v_BAD_DATE_INDICATOR) THEN @v_END_OF_TIME_DATE
                WHEN LEN(RTRIM(t.pay_through_date)) < 8 THEN @v_BAD_DATE_INDICATOR
                ELSE COALESCE(TRY_CONVERT(datetime, t.pay_through_date), @v_BAD_DATE_INDICATOR)
              END AS pay_through_date
            , CASE
                WHEN (RTRIM(t.emp_death_date) = @v_BAD_DATE_INDICATOR) THEN @v_END_OF_TIME_DATE
                WHEN LEN(RTRIM(t.emp_death_date)) < 8 THEN @v_BAD_DATE_INDICATOR
                ELSE COALESCE(TRY_CONVERT(datetime, t.emp_death_date), @v_BAD_DATE_INDICATOR)
              END AS emp_death_date
            , LEFT(t.consider_for_rehire_ind, 1) AS consider_for_rehire_ind
            , UPPER(LEFT(t.pay_element_id, 10)) AS pay_element_id
            , COALESCE(TRY_CONVERT(money, t.emp_calculation), 0.00) AS emp_calculation
            , LEFT(t.tax_flag, 1) AS tax_flag        -- CASE t.tax_flag WHEN '1' THEN 'Y' WHEN '0' THEN 'N' ELSE tax_flag END tax_flag
            , LEFT(t.nic_flag, 1) AS nic_flag        -- CASE t.nic_flag WHEN '1' THEN 'Y' WHEN '0' THEN 'N' ELSE nic_flag END nic_flag
            , COALESCE(TRY_CONVERT(money, t.tax_ceiling_amt), 0.00) AS tax_ceiling_amt
            , LEFT(t.labor_grp_code, 50) AS labor_grp_code
            , LEFT(t.file_source, 50) AS file_source
            , COALESCE(TRY_CONVERT(money, t.annual_hrs_per_fte), 0.00) AS annual_hrs_per_fte
            , COALESCE(TRY_CONVERT(money, t.annual_rate), 0.00) AS annual_rate
            , CASE
                WHEN (RTRIM(t.birth_date) = @v_BAD_DATE_INDICATOR) THEN @v_END_OF_TIME_DATE
                WHEN LEN(RTRIM(t.birth_date)) < 8 THEN @v_BAD_DATE_INDICATOR
                ELSE COALESCE(TRY_CONVERT(datetime, t.birth_date), @v_BAD_DATE_INDICATOR)
              END AS birth_date
            , LEFT(t.gender, 1) AS gender
            , LEFT(CASE t.country_code WHEN 'LCA' THEN 'EC1' ELSE 'GN4' END, 6) AS addr_fmt_code    -- derive address format code based on country code
            , LEFT(t.country_code, 2) AS country_code
            , LEFT(t.addr_line_1, 35) AS addr_line_1
            , LEFT(t.addr_line_2, 35) AS addr_line_2
            , LEFT(CASE t.country_code WHEN 'LCA' THEN LTRIM(RTRIM(t.addr_line_3 + ' ' + t.addr_line_4)) ELSE t.addr_line_3 END, 35) AS addr_line_3        -- combine line 3 and 4 if St Lucia
            , LEFT(CASE t.country_code WHEN 'LCA' THEN @v_EMPTY_SPACE ELSE t.addr_line_4 END, 35) AS addr_line_4
            , LEFT(t.city_name, 35) AS city_name
            , LEFT(t.state_prov, 9) AS state_prov
            , LEFT(t.postal_code, 9) AS postal_code
            , LEFT(t.county_name, 255) AS county_name
            , LEFT(t.region_name, 255) AS region_name
            , DBShrpn.dbo.ufn_ret_job_or_pos_id(t.file_source, t.empl_id) AS job_or_pos_id

		FROM dbo.ghr_employee_events t


	END TRY
	BEGIN CATCH
		IF ERROR_NUMBER() IN (8152, 2628)
			PRINT 'Truncation error detected in: ' + ERROR_MESSAGE();
		ELSE
			THROW
	END CATCH


	--select *
	--from dbo.ghr_employee_events


	DROP TABLE #ghr_employee_events_temp

END
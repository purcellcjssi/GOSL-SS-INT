USE DBShrpn
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

IF OBJECT_ID(N'dbo.ghr_debug', N'U') IS NOT NULL
BEGIN
    DROP TABLE dbo.ghr_debug
    IF OBJECT_ID(N'dbo.ghr_debug') IS NOT NULL
        PRINT N'<<< FAILED DROPPING TABLE dbo.ghr_debug >>>'
    ELSE
        PRINT N'<<< DROPPED TABLE dbo.ghr_debug >>>'
END
GO


CREATE TABLE dbo.ghr_debug
    (
      row_id            int	IDENTITY(1,1)   NOT NULL
    , text_line         varchar(255)        NOT NULL
)
GO

ALTER AUTHORIZATION ON dbo.ghr_debug TO  SCHEMA OWNER
GO




IF OBJECT_ID(N'dbo.ghr_debug', N'U') IS NOT NULL
    PRINT N'<<< CREATED TABLE dbo.ghr_debug >>>'
ELSE
    PRINT N'<<< FAILED CREATING TABLE dbo.ghr_debug >>>'
GO
 
USE DBShrpn
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

IF OBJECT_ID(N'dbo.ghr_employee_events', N'U') IS NOT NULL
BEGIN
    DROP TABLE dbo.ghr_employee_events
    IF OBJECT_ID(N'dbo.ghr_employee_events') IS NOT NULL
        PRINT N'<<< FAILED DROPPING TABLE dbo.ghr_employee_events >>>'
    ELSE
        PRINT N'<<< DROPPED TABLE dbo.ghr_employee_events >>>'
END
GO


CREATE TABLE dbo.ghr_employee_events
    (
      event_id                              char(2)             NULL
    , emp_id                                char(15)            NULL
    , eff_date                              char(10)            NULL
    , first_name                            char(25)            NULL
    , first_middle_name                     char(25)            NULL
    , last_name                             char(30)            NULL
    , empl_id                               char(10)            NULL
    , national_id_type_code                 char(5)             NULL
    , national_id                           char(20)            NULL
    , organization_group_id                 char(5)             NULL
    , organization_chart_name               char(64)            NULL
    , organization_unit_name                char(240)           NULL
    , emp_status_classn_code                char(2)             NULL
    , position_title                        char(60)            NULL
    , employment_type_code                  varchar(70)         NULL    -- increased size to 70 from 5
    , annual_salary_amt                     char(15)            NULL
    , begin_date                            char(10)            NULL
    , end_date                              char(10)            NULL
    , pay_status_code                       char(1)             NULL
    , pay_group_id                          char(10)            NULL
    , pay_element_ctrl_grp_id               char(10)            NULL
    , time_reporting_meth_code              char(1)             NULL
    , employment_info_chg_reason_cd         char(5)             NULL
    , emp_location_code                     char(10)            NULL
    , emp_status_code                       char(2)             NULL
    , reason_code                           char(2)             NULL
    , emp_expected_return_date              char(10)            NULL
    , pay_through_date                      char(10)            NULL
    , emp_death_date                        char(10)            NULL
    , consider_for_rehire_ind               char(1)             NULL
    , pay_element_id                        char(10)            NULL
    , emp_calculation                       char(15)            NULL
    , tax_flag                              char(1)             NULL    -- individual_personal.user_ind_2
    , nic_flag                              char(1)             NULL    -- individual_personal.user_ind_1
    , tax_ceiling_amt                       char(15)            NULL    -- employee.user_monetary_amt_1
    , labor_grp_code                        char(50)            NULL    -- emp_assignment.user_text_1
    , file_source                           char(50)            NULL    -- 'SS VENUS' or 'SS GANYMEDE'

    , annual_hrs_per_fte                    varchar(255)        NULL
    , annual_rate                           varchar(255)        NULL
    , birth_date                            varchar(255)        NULL
    , gender                                varchar(255)        NULL
    , country_code                          varchar(255)        NULL
    , addr_line_1                           varchar(255)        NULL
    , addr_line_2                           varchar(255)        NULL
    , addr_line_3                           varchar(255)        NULL
    , addr_line_4                           varchar(255)        NULL
    , city_name                             varchar(255)        NULL
    , state_prov                            varchar(255)        NULL
    , postal_code                           varchar(255)        NULL
    , county_name                           varchar(255)        NULL
    , region_name                           varchar(255)        NULL
)
GO

ALTER AUTHORIZATION ON dbo.ghr_employee_events TO  SCHEMA OWNER
GO


CREATE NONCLUSTERED INDEX idx_ncl_employee_events ON dbo.ghr_employee_events
(
	  event_id ASC
	, emp_id ASC
	, eff_date ASC
	, emp_status_code ASC
	, pay_element_id ASC
)WITH (
        PAD_INDEX = OFF
      , STATISTICS_NORECOMPUTE = OFF
      , SORT_IN_TEMPDB = OFF
      , IGNORE_DUP_KEY = OFF
      , DROP_EXISTING = OFF
      , ONLINE = OFF
      , ALLOW_ROW_LOCKS = ON
      , ALLOW_PAGE_LOCKS = ON
      )
GO

IF OBJECT_ID(N'dbo.ghr_employee_events', N'U') IS NOT NULL
    PRINT N'<<< CREATED TABLE dbo.ghr_employee_events >>>'
ELSE
    PRINT N'<<< FAILED CREATING TABLE dbo.ghr_employee_events >>>'
GO
 
USE DBShrpn
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

IF OBJECT_ID(N'dbo.ghr_employee_events_aud', N'U') IS NOT 		NULL
BEGIN
    DROP TABLE dbo.ghr_employee_events_aud
    IF OBJECT_ID(N'dbo.ghr_employee_events_aud') IS NOT 		NULL
        PRINT N'<<< FAILED DROPPING TABLE dbo.ghr_employee_events_aud >>>'
    ELSE
        PRINT N'<<< DROPPED TABLE dbo.ghr_employee_events_aud >>>'
END
GO

CREATE TABLE dbo.ghr_employee_events_aud
    (
      event_id                              char(2)             NOT NULL
    , emp_id                                char(15)            NOT NULL
    , eff_date                              datetime            NOT NULL
    , first_name                            char(25)            NULL
    , first_middle_name                     char(25)            NULL
    , last_name                             char(30)            NULL
    , empl_id                               char(10)            NULL
    , national_id_type_code                 char(5)             NULL
    , national_id                           char(20)            NULL
    , organization_group_id                 int                 NOT NULL
    , organization_chart_name               char(64)            NULL
    , organization_unit_name                char(240)           NULL
    , emp_status_classn_code                char(2)             NULL
    , position_title                        char(60)            NULL
    , employment_type_code                  varchar(70)         NULL    -- increased size to 70 from 5
    , annual_salary_amt                     money               NOT NULL
    , begin_date                            datetime            NOT NULL
    , end_date                              datetime            NOT NULL
    , pay_status_code                       char(1)             NULL
    , pay_group_id                          char(10)            NULL
    , pay_element_ctrl_grp_id               char(10)            NULL
    , time_reporting_meth_code              char(1)             NULL
    , employment_info_chg_reason_cd         char(5)             NULL
    , emp_location_code                     char(10)            NULL
    , emp_status_code                       char(2)             NULL
    , reason_code                           char(2)             NULL
    , emp_expected_return_date              char(10)            NULL
    , pay_through_date                      datetime            NOT NULL
    , emp_death_date                        datetime            NOT NULL
    , consider_for_rehire_ind               char(1)             NULL
    , pay_element_id                        char(10)            NULL
    , emp_calculation                       money               NOT NULL
    , tax_flag                              char(1)				NULL    -- individual_personal.user_ind_2
    , nic_flag                              char(1)				NULL    -- individual_personal.user_ind_1
    , tax_ceiling_amt                       money               NOT NULL    -- employee.user_monetary_amt_1
    , labor_grp_code                        char(50)			NULL    -- emp_assignment.user_text_1
    , file_source                           char(50)			NULL    -- 'SS VENUS' or 'SS GANYMEDE'
    , annual_hrs_per_fte                    money               NOT NULL
    , annual_rate                           money               NOT NULL
    , birth_date                            datetime            NOT NULL
    , gender                                char(01)        NULL
    , addr_fmt_code                         char(06)            NULL    -- Derived column based on country code SLA=EC1 ELSE GN4
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
    , activity_date                         datetime			NOT NULL
    , aud_id                                int                 NOT NULL    -- sequence number generated from temp table in sp usp_sel_employee_events
	, activity_user                         char(30)			NOT NULL
    , proc_flag                             char(01)            NOT NULL            -- Y/N Flag indicates if record was successfully processed
    , CONSTRAINT PK_ghr_employee_events_aud PRIMARY KEY CLUSTERED (activity_date, aud_id)
)
GO


ALTER AUTHORIZATION ON dbo.ghr_employee_events_aud TO  SCHEMA OWNER
GO


CREATE NONCLUSTERED INDEX idx_ncl_ghr_employee_events_aud ON dbo.ghr_employee_events_aud
    (
      activity_date
    , aud_id
    , event_id
    , emp_id
    , eff_date
	, proc_flag
    )
GO


IF OBJECT_ID(N'dbo.ghr_employee_events_aud', N'U') IS NOT NULL
    PRINT N'<<< CREATED TABLE dbo.ghr_employee_events_aud >>>'
ELSE
    PRINT N'<<< FAILED CREATING TABLE dbo.ghr_employee_events_aud >>>'
GO
 
USE DBShrpn
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID(N'dbo.ghr_historical_message', N'U') IS NOT NULL
BEGIN
    DROP TABLE dbo.ghr_historical_message
    IF OBJECT_ID(N'dbo.ghr_historical_message') IS NOT NULL
        PRINT N'<<< FAILED DROPPING TABLE dbo.ghr_historical_message >>>'
    ELSE
        PRINT N'<<< DROPPED TABLE dbo.ghr_historical_message >>>'
END
GO

CREATE TABLE dbo.ghr_historical_message
    (
      msg_id                        char(15)            NOT NULL
	, event_id                      char(2)             NOT NULL
	, emp_id                        char(15)            NOT NULL
	, eff_date                      datetime            NOT NULL
	, pay_element_id                char(10)            NOT NULL    -- decreased size to char(10) from varchar(20)
	, msg_p1                        varchar(255)        NOT NULL
	, msg_p2                        varchar(255)        NOT NULL
	, msg_desc                      varchar(4000)       NOT NULL
    , activity_status               char(02)            NOT NULL
	, activity_date                 datetime            NOT NULL
    , aud_id                        int                 NOT NULL    -- Added to improve data integrity with table ghr_employee_events_aud
    )
GO

ALTER AUTHORIZATION ON dbo.ghr_historical_message TO  SCHEMA OWNER
GO


CREATE CLUSTERED INDEX idx_cl_ghr_historical_message ON dbo.ghr_historical_message
   (
     activity_date
   , aud_id
   , event_id
   , msg_id
   , emp_id
   , eff_date
   )
  WITH (
        PAD_INDEX = OFF,
        FILLFACTOR = 90
       )
GO


IF OBJECT_ID(N'dbo.ghr_historical_message', N'U') IS NOT NULL
    PRINT N'<<< CREATED TABLE dbo.ghr_historical_message >>>'
ELSE
    PRINT N'<<< FAILED CREATING TABLE dbo.ghr_historical_message >>>'
GO
 

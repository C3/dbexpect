requires 'spec/fixtures/test_sets/sb_s_contact_defaults.rb'
requires 'spec/fixtures/test_sets/sb_s_case_defaults.rb'
requires 'spec/fixtures/test_sets/sb_s_case_xm_defaults.rb'
requires 'spec/fixtures/test_sets/accommodation_defaults.rb'
requires 'spec/fixtures/test_sets/clnt_case_srvc_typ_defaults.rb'

describe "unit test cases for ODS.ACCOMMODATION" do

  @case = table(:HSD,:SB_S_CASE)
  @dmb = table(:HSD,:SB_S_CASE_XM)
  @contact = table(:HSD,:SB_S_CONTACT)
  @service_type = table(:ODS,:CLNT_CASE_SRVC_TYP)
  @accom = table(:ODS,:ACCOMMODATION)

  all_tables :ACIT_ARCH_TIER => 'ODS',
             :ACIT_COMP => '',
             :ACIT_ENV => 'DEV',
             :ACIT_LOAD_TYPE => 'INITIAL',
             :ACIT_PROJ => 'IMA',
             :ACIT_RESTART_PT => '',
             :ACIT_STORY => 'IMA-286:IMA-302',
             :ACIT_SUBJ_AREA => '',
             :ACIT_TIME_POINT => '2000-01-01 00:00:00.000000',
             :ACIT_TOOL => ''

  defaults_for @case,
   :STATUS_CD=>"Finalised",
   :CLASS_CD=>"Service"

  defaults_for @dmb,
    :TYPE => 'Detention Managed By',
    :IBMSNAP_OPERATION => 'U',
    :ATTRIB_34 => NULL,
    :ATTRIB_45 => 'Location description',
    :ATTRIB_26 => '2010-03-22 01:01:01.000000', # start date
    :ATTRIB_33 => '2012-03-13 00:00:00.000000' # end date

  expected_defaults @accom,
    :COL1 => 'COL1 Default Value'

  describe "test case 1, perfect row" do
    all_tables :ACIT_BUS_RULES => 'ODS.ACCOMMODATION_01'

    insert_into @contact,
      [:ROW_ID],
      [['CONTACT-01']]

    insert_into @case,
      [:ROW_ID, :TYPE_CD, :PAR_CASE_ID, :PR_SUBJECT_ID],
      [
        ['CASE_CSE-01','Client Case',NULL, 'CONTACT-01'],
        ['CASE_CSR-01','Accommodation and Care','CASE_CSE-01',NULL]
      ]

    insert_into @dmb,
      [:ROW_ID, :PAR_ROW_ID],
      [['CASE_DETN-01', 'CASE_CSR-01']]

    insert_into @service_type,
      [:SB_SRVC_ID, :CLNT_CASE_SRVC_TYP_SK],
      [
        ['CASE_CSE-01',1]
      ]

    expect_rows @accom,
      [:COL2],
      [[1]]
  end

  describe "test case 2, null value end date" do
    all_tables :ACIT_BUS_RULES => 'ODS.ACCOMMODATION_02'

    insert_into @contact,
      [:ROW_ID],
      [['CONTACT-02']]

    insert_into @case,
      [:ROW_ID, :TYPE_CD, :PAR_CASE_ID, :PR_SUBJECT_ID],
      [
        ['CASE_CSE-02','Client Case',NULL, 'CONTACT-02'],
        ['CASE_CSR-02','Accommodation and Care','CASE_CSE-02',NULL]
      ]

    insert_into @dmb,
      [:ROW_ID, :PAR_ROW_ID, :ATTRIB_33],
      [['CASE_DETN-02', 'CASE_CSR-02', NULL]]

    insert_into @service_type,
      [:SB_SRVC_ID, :CLNT_CASE_SRVC_TYP_SK],
      [
        ['CASE_CSE-02',2]
      ]

    expect_rows @accom,
      [:COL2],
      [[2]]
  end

  describe "test case 3, case status not active or finalised" do
    all_tables :ACIT_BUS_RULES => 'ODS.ACCOMMODATION_03'

    insert_into @contact,
      [:ROW_ID],
      [['CONTACT-03']]

    insert_into @case,
      [:ROW_ID, :STATUS_CD, :TYPE_CD, :PAR_CASE_ID, :PR_SUBJECT_ID],
      [
        ['CASE_CSE-03','Wrong value', 'Client Case',NULL, 'CONTACT-03'],
        ['CASE_CSR-03','Active', 'Accommodation and Care','CASE_CSE-03',NULL]
      ]

    insert_into @dmb,
      [:ROW_ID, :PAR_ROW_ID],
      [['CASE_DETN-03', 'CASE_CSR-03']]

    insert_into @service_type,
      [:SB_SRVC_ID, :CLNT_CASE_SRVC_TYP_SK],
      [
        ['CASE_CSE-03',3]
      ]
  end

  describe "test case 4, case not type client case" do
    all_tables :ACIT_BUS_RULES => 'ODS.ACCOMMODATION_04'

    insert_into @contact,
      [:ROW_ID],
      [['CONTACT-04']]

    insert_into @case,
      [:ROW_ID, :TYPE_CD, :PAR_CASE_ID, :PR_SUBJECT_ID],
      [
        ['CASE_CSE-04','Not Client Case',NULL, 'CONTACT-04'],
        ['CASE_CSR-04','Accommodation and Care','CASE_CSE-04',NULL]
      ]

    insert_into @dmb,
      [:ROW_ID, :PAR_ROW_ID],
      [['CASE_DETN-04', 'CASE_CSR-04']]

    insert_into @service_type,
      [:SB_SRVC_ID, :CLNT_CASE_SRVC_TYP_SK],
      [
        ['CASE_CSE-04',4]
      ]
  end

  describe "test case 5, Accomodation care not active or finalised" do
    all_tables :ACIT_BUS_RULES => 'ODS.ACCOMMODATION_05'

    insert_into @contact,
      [:ROW_ID],
      [['CONTACT-05']]

    insert_into @case,
      [:ROW_ID, :STATUS_CD, :TYPE_CD, :PAR_CASE_ID, :PR_SUBJECT_ID],
      [
        ['CASE_CSE-05','Active','Client Case',NULL, 'CONTACT-05'],
        ['CASE_CSR-05','Wrong status','Accommodation and Care','CASE_CSE-05',NULL]
      ]

    insert_into @dmb,
      [:ROW_ID, :PAR_ROW_ID],
      [['CASE_DETN-05', 'CASE_CSR-05']]

    insert_into @service_type,
      [:SB_SRVC_ID, :CLNT_CASE_SRVC_TYP_SK],
      [
        ['CASE_CSE-05',5]
      ]
  end

  describe "test case 6, CSR not accom care" do
    all_tables :ACIT_BUS_RULES => 'ODS.ACCOMMODATION_06'

    insert_into @contact,
      [:ROW_ID],
      [['CONTACT-06']]

    insert_into @case,
      [:ROW_ID, :TYPE_CD, :PAR_CASE_ID, :PR_SUBJECT_ID],
      [
        ['CASE_CSE-06','Active','Client Case',NULL, 'CONTACT-06'],
        ['CASE_CSR-06','NOT Accommodation and Care','CASE_CSE-06',NULL]
      ]

    insert_into @dmb,
      [:ROW_ID, :PAR_ROW_ID],
      [['CASE_DETN-06', 'CASE_CSR-06']]

    insert_into @service_type,
      [:SB_SRVC_ID, :CLNT_CASE_SRVC_TYP_SK],
      [
        ['CASE_CSE-06',6]
      ]
  end

  describe "test case 7, CSR not type Service" do
    all_tables :ACIT_BUS_RULES => 'ODS.ACCOMMODATION_07'

    insert_into @contact,
      [:ROW_ID],
      [['CONTACT-07']]

    insert_into @case,
      [:ROW_ID, :TYPE_CD, :PAR_CASE_ID, :PR_SUBJECT_ID, :CLASS_CD],
      [
        ['CASE_CSE-07','Client Case',NULL, 'CONTACT-07', 'anything'],
        ['CASE_CSR-07','Accommodation and Care','CASE_CSE-07',NULL, 'NOT Service']
      ]

    insert_into @dmb,
      [:ROW_ID, :PAR_ROW_ID],
      [['CASE_DETN-07', 'CASE_CSR-07']]

    insert_into @service_type,
      [:SB_SRVC_ID, :CLNT_CASE_SRVC_TYP_SK],
      [
        ['CASE_CSE-07',7]
      ]
  end

  describe "test case 8, No detention managed by record" do
    all_tables :ACIT_BUS_RULES => 'ODS.ACCOMMODATION_08'

    insert_into @contact,
      [:ROW_ID],
      [['CONTACT-08']]

    insert_into @case,
      [:ROW_ID, :TYPE_CD, :PAR_CASE_ID, :PR_SUBJECT_ID ],
      [
        ['CASE_CSE-08','Client Case',NULL, 'CONTACT-08'],
        ['CASE_CSR-08','Accommodation and Care','CASE_CSE-08',NULL]
      ]

    insert_into @dmb,
      [:ROW_ID, :PAR_ROW_ID, :TYPE],
      [['CASE_DETN-08', 'CASE_CSR-08', 'NOT Detention Managed By']]

    insert_into @service_type,
      [:SB_SRVC_ID, :CLNT_CASE_SRVC_TYP_SK],
      [
        ['CASE_CSE-08',8]
      ]
  end

  describe "test case 9, attrib_34 not null" do
    all_tables :ACIT_BUS_RULES => 'ODS.ACCOMMODATION_09'

    insert_into @contact,
      [:ROW_ID],
      [['CONTACT-09']]

    insert_into @case,
      [:ROW_ID, :TYPE_CD, :PAR_CASE_ID, :PR_SUBJECT_ID ],
      [
        ['CASE_CSE-09','Client Case',NULL, 'CONTACT-09'],
        ['CASE_CSR-09','Accommodation and Care','CASE_CSE-09',NULL]
      ]

    insert_into @dmb,
      [:ROW_ID, :PAR_ROW_ID, :ATTRIB_34],
      [['CASE_DETN-09', 'CASE_CSR-09', 'not null']]

    insert_into @service_type,
      [:SB_SRVC_ID, :CLNT_CASE_SRVC_TYP_SK],
      [
        ['CASE_CSE-09',9]
      ]
  end

  describe "test case 10, run_sk on client case triggers load" do
    all_tables :ACIT_BUS_RULES => 'ODS.ACCOMMODATION_10'

    insert_into @contact,
      [:ROW_ID, :RUN_SK],
      [['CONTACT-10',19999]]

    insert_into @case,
      [:ROW_ID, :TYPE_CD, :PAR_CASE_ID, :PR_SUBJECT_ID, :RUN_SK ],
      [
        ['CASE_CSE-10','Client Case',NULL, 'CONTACT-10', 20000],
        ['CASE_CSR-10','Accommodation and Care','CASE_CSE-10',NULL, 19999]
      ]

    insert_into @dmb,
      [:ROW_ID, :PAR_ROW_ID, :RUN_SK],
      [['CASE_DETN-10', 'CASE_CSR-10', 19999]]

    insert_into @service_type,
      [:SB_SRVC_ID, :CLNT_CASE_SRVC_TYP_SK],
      [
        ['CASE_CSE-10',10]
      ]

    expect_rows @accom,
      [:COL2],
      [[10]]
  end

  describe "test case 11, run_sk on dmb triggers load" do
    all_tables :ACIT_BUS_RULES => 'ODS.ACCOMMODATION_11'

    insert_into @contact,
      [:ROW_ID, :RUN_SK],
      [['CONTACT-11',19999]]

    insert_into @case,
      [:ROW_ID, :TYPE_CD, :PAR_CASE_ID, :PR_SUBJECT_ID, :RUN_SK ],
      [
        ['CASE_CSE-11','Client Case',NULL, 'CONTACT-11', 19999],
        ['CASE_CSR-11','Accommodation and Care','CASE_CSE-11',NULL, 19999]
      ]

    insert_into @dmb,
      [:ROW_ID, :PAR_ROW_ID, :RUN_SK],
      [['CASE_DETN-11', 'CASE_CSR-11', 20000]]

    insert_into @service_type,
      [:SB_SRVC_ID, :CLNT_CASE_SRVC_TYP_SK],
      [
        ['CASE_CSE-11',11]
      ]

      expect_rows @accom,
        [:COL2],
        [[11]]
  end

  describe "test case 12, no run_sk change, no records loaded" do
    all_tables :ACIT_BUS_RULES => 'ODS.ACCOMMODATION_11'

    insert_into @contact,
      [:ROW_ID, :RUN_SK],
      [['CONTACT-12',19999]]

    insert_into @case,
      [:ROW_ID, :TYPE_CD, :PAR_CASE_ID, :PR_SUBJECT_ID, :RUN_SK ],
      [
        ['CASE_CSE-12','Client Case',NULL, 'CONTACT-12', 19999],
        ['CASE_CSR-12','Accommodation and Care','CASE_CSE-12',NULL, 19999]
      ]

    insert_into @dmb,
      [:ROW_ID, :PAR_ROW_ID, :RUN_SK],
      [['CASE_DETN-12', 'CASE_CSR-12', 19999]]

    insert_into @service_type,
      [:SB_SRVC_ID, :CLNT_CASE_SRVC_TYP_SK],
      [
        ['CASE_CSE-12',12]
      ]
  end

  describe "test case 13, IBMSNAP set to D" do
    all_tables :ACIT_BUS_RULES => 'ODS.ACCOMMODATION_13'

    insert_into @contact,
      [:ROW_ID],
      [['CONTACT-13']]

    insert_into @case,
      [:ROW_ID, :TYPE_CD, :PAR_CASE_ID, :PR_SUBJECT_ID ],
      [
        ['CASE_CSE-13','Client Case',NULL, 'CONTACT-13'],
        ['CASE_CSR-13','Accommodation and Care','CASE_CSE-13',NULL]
      ]

    insert_into @dmb,
      [:ROW_ID, :PAR_ROW_ID, :IBMSNAP_OPERATION],
      [['CASE_DETN-13', 'CASE_CSR-13', 'D']]

    insert_into @service_type,
      [:SB_SRVC_ID, :CLNT_CASE_SRVC_TYP_SK],
      [
        ['CASE_CSE-13',13]
      ]

    expect_rows @accom,
      [:COL2],
      [[13]]
  end

  describe "test case 14, IBMSNAP not set to D" do
    all_tables :ACIT_BUS_RULES => 'ODS.ACCOMMODATION_14'

    insert_into @contact,
      [:ROW_ID],
      [['CONTACT-14']]

    insert_into @case,
      [:ROW_ID, :TYPE_CD, :PAR_CASE_ID, :PR_SUBJECT_ID ],
      [
        ['CASE_CSE-14','Client Case',NULL, 'CONTACT-14'],
        ['CASE_CSR-14','Accommodation and Care','CASE_CSE-14',NULL]
      ]

    insert_into @dmb,
      [:ROW_ID, :PAR_ROW_ID, :IBMSNAP_OPERATION],
      [['CASE_DETN-14', 'CASE_CSR-14', 'X']]

    insert_into @service_type,
      [:SB_SRVC_ID, :CLNT_CASE_SRVC_TYP_SK],
      [
        ['CASE_CSE-14',14]
      ]

    expect_rows @accom,
      [:COL2],
      [[14]]
  end
end

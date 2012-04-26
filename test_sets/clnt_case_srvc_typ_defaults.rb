@type = table(:ODS,:CLNT_CASE_SRVC_TYP)

defaults_for @type,
  :CLNT_CASE_SRVC_TYP_SK => DbSequence.new,
  :CLNT_CASE_SK => NULL,
  :SB_SRVC_TYP_CD => 'stub',
  :SB_SRVC_SB_TYP_CD => 'stub',
  :SB_SRVC_SB_TYP_NM => 'stub',
  :SB_SRVC_ID => 'stub',
  :SB_SRVC_STS => 'stub',
  :SB_SRVC_SUB_STS => 'stub',
  :SB_SRVC_STT => 'stub',
  :ODS_EFCTV_CD => 'I',
  :DW_ACTN_CD => 'I',
  :RUN_SK => 20000

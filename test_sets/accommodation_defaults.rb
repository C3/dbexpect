@accom = table(:ODS,:ACCOMMODATION)

defaults_for @accom,
  :ACCOMMODATION_SK => DbSequence.new,
  :CLNT_CASE_SRVC_TYP_SK => NULL,
  :LCTN_STRT_DT => "2010-03-09 00:45:49.000000",
  :LCTN_END_DT => "2012-03-09 00:45:49.000000",
  :DTNN_LCTN_CD => 'CODE',
  :DTNN_LCTN_DS => 'Location description',
  :ODS_EFCTV_CD => 'I',
  :DW_ACTN_CD => 'I',
  :RUN_SK => 20000


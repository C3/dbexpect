@src = table(:dbexpect_src,:source,:src_table)

defaults_for @src,
  :str_column => "default string",
  :nullable_col => NULL

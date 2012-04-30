requires 'spec/fixtures/defaults.rb'

describe "our basic test definition test" do
  @src = table(:source,:src_table)
  @tgt = table(:target,:tgt_table)

  expected_defaults @tgt,
    :str_column => 'defaulted in script',
    :int_column => 5


  insert_into @src,
    [:int_column],
    [[7]]

  expect_rows @tgt,
    [:nullable_col],
    [
      [NULL],
      [nil],
      [null],
      [4] ]

  describe "nested definition" do
    insert_into @src,
      [:str_column,:int_column,:nullable_col],
      [
        ['overridden string',1,'not null'] ]
  end

end

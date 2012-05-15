requires 'spec/fixtures/defaults.rb'

describe "our basic test definition test" do
  @src = table(:source,:src_table)
  @tgt = table(:target,:tgt_table)

  expected_defaults @tgt,
    :str_column => 'defaulted in script',
    :int_column => 5

  expect_total_rows @tgt, 5

  describe "test case 1" do
    insert_into @src,
      [:int_column],
      [[7]]

    expect_rows @tgt,
      [:int_column,:nullable_col],
      [
        [1,NULL],
        [2,nil],
        [3,null],
        [4,4] ]
  end

  describe "nested definition" do
    insert_into @src,
      [:str_column,:int_column,:nullable_col],
      [
        ['overridden string',1,'not null'] ]

    expect_rows @tgt,
      [:str_column,:nullable_col],
      [
        ['special row',6]]
  end

end

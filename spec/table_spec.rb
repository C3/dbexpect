require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Table do

  describe "validating expectations against the database" do
    before :each do
      @table_expectations = mock()
      @it = Table.new('schema','tablename',@table_expectations)

      @db = mock
    end

    it "should gather failure messages for failed expectations" do
      @table_expectations.stub!(:where_clauses => ['clause1', 'clause2'])

      @db.should_receive(:num_rows_match).with('schema','tablename','clause1').
        and_return(2)
      @db.should_receive(:num_rows_match).with('schema','tablename','clause2').
        and_return(0)

      @it.check_expectations(@db)
      @it.failed_expectations.should == [
        "Expected one row to match clause1, got 2",
        "Expected one row to match clause2, got 0"
      ]
    end

    it "should gather failure messages for exception-causing" do
      @table_expectations.stub!(:where_clauses => ['bad query'])

      @db.should_receive(:num_rows_match).with('schema','tablename','bad query').
        and_raise(OdbcConnection::DatabaseException.new('error message'))

      @it.check_expectations(@db)
      @it.failed_expectations.should == [
        "Expected one row to match bad query, instead database raised error: error message",
      ]
    end
  end
end

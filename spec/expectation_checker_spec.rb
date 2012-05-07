require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe ExpectationChecker do
  describe "validating expectations against the database" do
    before :each do
      @expected_rows = []
      @db = mock

      @it = ExpectationChecker.new(@db)
    end

    def stub_row(where_clause)
      mock(:where_clause => where_clause)
    end

    it "should gather failure messages for failed expectations" do
      @expected_rows << stub_row('clause1')
      @expected_rows << stub_row('clause2')

      @db.should_receive(:num_rows_match).with('schema','tablename','clause1').
        and_return(2)
      @db.should_receive(:num_rows_match).with('schema','tablename','clause2').
        and_return(0)

      @it.check_expectations('schema','tablename',@expected_rows)
      @it.failed_expectations.should == [
        "Expected one row to match clause1, got 2",
        "Expected one row to match clause2, got 0"
      ]
    end

    it "should gather failure messages for exception-causing" do
      @expected_rows << stub_row('bad query')

      @db.should_receive(:num_rows_match).with('schema','tablename','bad query').
        and_raise(OdbcConnection::DatabaseException.new('error message'))

      @it.check_expectations('schema','tablename',@expected_rows)
      @it.failed_expectations.should == [
        "Expected one row to match bad query, instead database raised error: error message",
      ]
    end
  end
end

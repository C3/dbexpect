require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe ExpectationChecker do
  describe "validating expectations against the database" do
    before :each do
      @expected_rows = []
      @db = mock

      @it = ExpectationChecker.new(@db,'schema','tablename')
    end

    def stub_row(where_clause)
      mock(:where_clause => where_clause)
    end

    it "should check row counts" do
      @db.should_receive(:num_rows_match).with('schema','tablename','1=1').
        and_return(7)

      @it.check_row_count(5)
      @it.failed_expectations.should == [
        "Expected 5 rows to match 1=1, got 7",
      ]
    end

    it "should gather failure messages for failed expectations" do
      @expected_rows << stub_row('clause1')
      @expected_rows << stub_row('clause2')

      @db.should_receive(:num_rows_match).with('schema','tablename','clause1').
        and_return(2)
      @db.should_receive(:num_rows_match).with('schema','tablename','clause2').
        and_return(0)

      @it.check_expectations(@expected_rows)
      @it.failed_expectations.should == [
        "Expected 1 row to match clause1, got 2",
        "Expected 1 row to match clause2, got 0"
      ]
    end

    it "should gather failure messages for exception-causing" do
      @expected_rows << stub_row('bad query')

      @db.should_receive(:num_rows_match).with('schema','tablename','bad query').
        and_raise(OdbcConnection::DatabaseException.new('error message'))

      @it.check_expectations(@expected_rows)
      @it.failed_expectations.should == [
        "Expected 1 row to match bad query, instead database raised error: error message",
      ]
    end
  end
end

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RowExpectation do
  describe "validating expectations against the database" do
    def stub_row(where_clause)
      mock(:where_clause => where_clause)
    end

    before :each do
      @db = mock
      @expected_row = stub_row('clause1')

      @it = RowExpectation.new('schema','tablename',@expected_row)
    end


    it "should gather failure messages for failed expectations" do
      @db.should_receive(:num_rows_match).with('schema','tablename','clause1').
        and_return(2)

      @it.validate_expectation(@db)
      @it.failed_validation?.should be_true
      @it.failure_message.should == "Expected schema.tablename to contain a row where clause1, got 2"
    end

    it "should gather failure messages for exception-causing" do
      @db.should_receive(:num_rows_match).with('schema','tablename','clause1').
        and_raise(OdbcConnection::DatabaseException.new('error message'))

      @it.validate_expectation(@db)
      @it.failed_validation?.should be_true
      @it.failure_message.should == "Expected schema.tablename to contain a row where clause1, instead database raised error: error message"
    end
  end
end

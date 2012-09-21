# Copyright 2012 C3 Business Solutions
#
#    This file is part of dbexpect.
#
#    dbexpect is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    dbexpect is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with dbexpect.  If not, see <http://www.gnu.org/licenses/>.
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RowExpectation do
  describe "validating expectations against the database" do
    def stub_row(where_clause)
      mock(:where_clause => where_clause)
    end

    before :each do
      @db = {:dbname => mock}
      @expected_row = stub_row('clause1')

      @it = RowExpectation.new(:dbname,'schema','tablename',@expected_row)
    end


    it "should gather failure messages for failed expectations" do
      @db[:dbname].should_receive(:num_rows_match).with('schema','tablename','clause1').
        and_return(2)

      @it.validate_expectation(@db)
      @it.failed_validation?.should be_true
      @it.failure_message.should == "Expected schema.tablename to contain a row where clause1, got 2"
    end

    it "should gather failure messages for exception-causing" do
      @db[:dbname].should_receive(:num_rows_match).with('schema','tablename','clause1').
        and_raise(OdbcConnection::DatabaseException.new('error message'))

      @it.validate_expectation(@db)
      @it.failed_validation?.should be_true
      @it.failure_message.should == "Expected schema.tablename to contain a row where clause1, instead database raised error: error message"
    end
  end
end

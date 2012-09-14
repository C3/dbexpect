# Copyright 2012 C3 Business Solutions
#
#    This file is part of Testgen.
#
#    Testgen is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    Testgen is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with Testgen.  If not, see <http://www.gnu.org/licenses/>.
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe ExpectationChecker do
  describe "validating expectations against the database" do
    before :each do
      @expectations = ExpectationTreeNode.new('root')
      @db = mock

      @it = ExpectationChecker.new(@db)
    end

    def stub_expectation(failure_msg)
      m = mock(:failed_validation? => !failure_msg.nil?, :failure_message => failure_msg)
      m.should_receive(:validate_expectation).with(@db)
      [m]
    end

    it "should gather failure messages for failed expectations" do
      @expectations.add stub_expectation('failure 1')
      @expectations.add stub_expectation(nil)
      @expectations.add stub_expectation('failure 2')

      @it.check_expectations(@expectations)
      @it.failed_expectations.collect(&:failure_message).should == [
        "failure 1",
        "failure 2"
      ]
    end

  end
end

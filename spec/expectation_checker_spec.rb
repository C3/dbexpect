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

class ExpectationChecker
  attr_accessor :failed_expectations
  def initialize(database)
    @db = database
    @failed_expectations = []
  end

  def check_expectations(expectations)
    expectations.each do |expect_node|
      expect_node.expectations.each do |expectation|
        expectation.validate_expectation(@db)
        if expectation.failed_validation?
          @failed_expectations << expectation.failure_message
        end
      end
    end
  end

  def validates_expectations?
    @failed_expectations.empty?
  end
end

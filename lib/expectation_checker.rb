class ExpectationChecker
  attr_accessor :failed_expectations
  def initialize(database)
    @db = database
    @failed_expectations = []
  end

  def check_expectations(expectations)
    expectations.map {|e| e.validate_expectation(@db) }

    failure_tree = expectations.select {|e| e.failed_validation? }

    @failed_expectations = failure_tree.collect(&:failure_message)
  end

  def validates_expectations?
    @failed_expectations.empty?
  end
end

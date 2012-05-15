class ExpectationChecker
  attr_accessor :failed_expectations
  def initialize(database)
    @db = database
  end

  def check_expectations(expectations)
    expectations.map {|e| e.validate_expectation(@db) }

    @failed_expectations = expectations.select {|e| e.failed_validation? }
  end

  def validates_expectations?
    @failed_expectations.empty?
  end
end

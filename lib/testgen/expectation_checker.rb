class ExpectationChecker
  attr_accessor :failed_expectations
  def initialize(databases)
    @databases = databases
  end

  def check_expectations(expectations)
    expectations.map {|e| e.validate_expectation(@databases) }

    @failed_expectations = expectations.select {|e| e.failed_validation? }
  end

  def validates_expectations?
    @failed_expectations.empty?
  end
end

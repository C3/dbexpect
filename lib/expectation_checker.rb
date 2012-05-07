class ExpectationChecker
  attr_accessor :failed_expectations
  def initialize(database)
    @db = database
  end

  def check_expectations(schema,name,expected_rows)
    @failed_expectations = []
    expected_rows.map(&:where_clause).map do |expectation|
      begin
        num = @db.num_rows_match(schema,name,expectation)
      rescue OdbcConnection::DatabaseException => e
        @failed_expectations << "Expected one row to match #{expectation}, instead database raised error: #{e.message}"
        next
      end

      if num != 1
        @failed_expectations << "Expected one row to match #{expectation}, got #{num}"
      end
    end
  end

  def validates_expectations?
    @failed_expectations.empty?
  end
end

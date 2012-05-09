class ExpectationChecker
  attr_accessor :failed_expectations
  def initialize(database,schema,name)
    @db = database
    @schema = schema
    @name = name
    @failed_expectations = []
  end

  def check_row_count(row_count)
    check_expectation('1=1',row_count)
  end

  def check_expectations(expected_rows)
    expected_rows.map(&:where_clause).map do |expectation|
      check_expectation(expectation,1)
    end
  end

  def check_expectation(expectation,num_expected)
    begin
      num = @db.num_rows_match(@schema,@name,expectation)
    rescue OdbcConnection::DatabaseException => e
      @failed_expectations << expect_msg(expectation,num_expected) + "instead database raised error: #{e.message}"
      return
    end

    if num != num_expected
      @failed_expectations << expect_msg(expectation,num_expected) + "got #{num}"
    end
  end

  def expect_msg(expectation,num)
    "Expected #{num} row#{num!= 1 ? 's' : ''} to match #{expectation}, "
  end

  def validates_expectations?
    @failed_expectations.empty?
  end
end

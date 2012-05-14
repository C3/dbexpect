class RowCountExpectation
  def initialize(schema,table,count)
    @schema = schema
    @table = table
    @count = count
  end

  def validate_expectation(database)
    begin
      num = database.num_rows_match(@schema,@table,'1=1')
    rescue OdbcConnection::DatabaseException => e
      puts e.inspect
      @failure = expect_msg + "instead database raised error: #{e.message}"
      return
    end

    if num != @count
      @failure = expect_msg + "got #{num}"
    end
  end

  def expect_msg
    "Expected #{@schema}.#{@table} to contain #{@count} rows, "
  end

  def failed_validation?
    @failure
  end

  def failure_message
    @failure
  end
end

class Expectation
  def initialize(schema,table)
    @schema = schema
    @table = table
  end

  def validate_expectation(database)
    begin
      num = database.num_rows_match(@schema,@table,where_clause)
    rescue OdbcConnection::DatabaseException => e
      @failure = expect_msg + "instead database raised error: #{e.message}"
      return
    end

    if num != @count
      @failure = expect_msg + "got #{num}"
    end
  end

  def failed_validation?
    @failure
  end

  def failure_message
    @failure
  end
end

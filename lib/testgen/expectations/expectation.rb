class Expectation
  def initialize(db_name,schema,table)
    @schema = schema
    @table = table
    @db_name = db_name
  end

  def validate_expectation(databases)
    database = databases[@db_name]
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

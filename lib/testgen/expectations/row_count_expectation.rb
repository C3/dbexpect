require_relative 'expectation'
class RowCountExpectation < Expectation
  def initialize(db_name,schema,table,count)
    @count = count
    super(db_name,schema,table)
  end

  def where_clause
    "1=1"
  end

  def expect_msg
    "Expected #{@schema}.#{@table} to contain #{@count} rows, "
  end

end

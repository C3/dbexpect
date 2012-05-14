require 'expectations/expectation'
class RowCountExpectation < Expectation
  def initialize(schema,table,count)
    @count = count
    super(schema,table)
  end

  def where_clause
    "1=1"
  end

  def expect_msg
    "Expected #{@schema}.#{@table} to contain #{@count} rows, "
  end

end

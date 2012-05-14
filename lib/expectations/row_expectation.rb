require 'expectations/expectation'
class RowExpectation < Expectation
  def initialize(schema,table,row_data)
    @row = row_data
    @count = 1
    super(schema,table)
  end

  def where_clause
    @row.where_clause
  end

  def expect_msg
    "Expected #{@schema}.#{@table} to contain a row where #{where_clause}, "
  end
end

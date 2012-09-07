require_relative 'expectation'
class RowExpectation < Expectation
  def initialize(db_name,schema,table,row_data)
    @row = row_data
    @count = 1
    super(db_name,schema,table)
  end

  def where_clause
    @row.where_clause
  end

  def expect_msg
    "Expected #{@schema}.#{@table} to contain a row where #{where_clause}, "
  end
end

require 'defaulting_row_set'
class Table
  attr_accessor :failed_expectations

  def initialize(schema,name, expectations = DefaultingRowSet.new)
    @schema = schema
    @name = name

    @tdr_rows = DefaultingRowSet.new
    @expectations = expectations
    @fixture_rows = DefaultingRowSet.new
  end

  def set_default(column,value)
    @tdr_rows.set_default(column, value)
    @fixture_rows.set_default(column, value)
  end

  def set_expected_default(column,value)
    @expectations.set_default(column,value)
    @tdr_rows.set_default(column,value)
  end

  def add_row(node,column_values)
    @tdr_rows.add_row(node,column_values)
    @fixture_rows.add_row(node,column_values)
  end

  def add_expected_row(node,column_values)
    @expectations.add_row(node,column_values)
    @tdr_rows.add_row(node,column_values)
  end

  def tdr_insert_stmt
    return '' if @tdr_rows.empty?

    stmt = <<SQL
INSERT INTO #{@schema}.#{@name} (#{@tdr_rows.columns})
VALUES #{@tdr_rows.values};
SQL
  end

  def check_expectations(database)
    @failed_expectations = []
    @expectations.where_clauses.map do |expectation|
      begin
        num = database.num_rows_match(@schema,@name,expectation)
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

require 'pry'
require 'defaulting_row_set'
class Table
  def initialize(schema,name)
    @schema = schema
    @name = name

    @tdr_rows = DefaultingRowSet.new
    @expectations = DefaultingRowSet.new
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

  def add_row(column_values)
    @tdr_rows.add_row(column_values)
    @fixture_rows.add_row(column_values)
  end

  def add_expected_row(column_values)
    @expectations.add_row(column_values)
    @tdr_rows.add_row(column_values)
  end

  def tdr_insert_stmt
    return '' if @tdr_rows.empty?

    stmt = <<SQL
INSERT INTO #{@schema}.#{@name} (#{@tdr_rows.columns})
VALUES #{@tdr_rows.values};
SQL
  end

  def validates_expectations?(database)
    @expectations.where_clauses.all? do |expectation|
      database.returns_one_row?(
        "select * from #{@schema}.#{@name} where (#{expectation})"
      )
    end
  end

end

require 'defaulting_row_set'
require 'expectation_checker'
require 'expectations/row_count_expectation'
require 'expectations/row_expectation'

class Table

  def initialize(schema,name)
    @schema = schema
    @name = name

    @tdr_rows = DefaultingRowSet.new
    @expected_row_factory = DefaultingRowSet.new
    @fixture_rows = DefaultingRowSet.new

    @expected_rows = []
    @dirty = false
    @row_count_check = false
  end

  def set_default(column,value)
    @tdr_rows.set_default(column, value)
    @fixture_rows.set_default(column, value)
  end

  def set_expected_default(column,value)
    @expected_row_factory.set_default(column,value)
    @tdr_rows.set_default(column,value)
  end

  def add_fixture_row(column_values)
    @tdr_rows.add_row(column_values)
    @fixture_rows.add_row(column_values)
  end

  def add_expected_row(column_values)
    @tdr_rows.add_row(column_values)
    new_expectation(@expected_row_factory.add_row(column_values))
  end

  def new_expectation(row)
    RowExpectation.new(@schema,@name,row)
  end

  def tdr_insert_stmt
    @tdr_rows.insert_statements(@schema,@name).map {|stmt| stmt + ';' }.join("\n")
  end

  attr_writer :dirty
  def set_up_for_test(database)
    unless @dirty
      database.truncate_table(@schema,@name)
    end
    database.insert_rows(@fixture_rows.insert_statements(@schema,@name))
  end

  attr_writer :row_count_check

  def table_expectations
    if @row_count_check
      [RowCountExpectation.new(@schema,@name,@row_count_check)]
    else
      []
    end
  end

end

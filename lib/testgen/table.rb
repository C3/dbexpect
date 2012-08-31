require_relative 'defaulting_row_set'
require_relative 'expectation_checker'
require_relative 'expectations/row_count_expectation'
require_relative 'expectations/row_expectation'

class Table

  def initialize(schema,name)
    @schema = schema
    @name = name

    @expected_row_factory = DefaultingRowSet.new
    @fixture_rows = DefaultingRowSet.new

    @dirty = false
  end

  def set_default(column,value)
    @fixture_rows.set_default(column, value)
  end

  def set_expected_default(column,value)
    @expected_row_factory.set_default(column,value)
  end

  def add_fixture_row(column_values)
    @fixture_rows.add_row(column_values)
  end

  def add_expected_row(column_values)
    new_expectation(@expected_row_factory.add_row(column_values))
  end

  def new_expectation(row)
    RowExpectation.new(@schema,@name,row)
  end

  attr_writer :dirty
  def set_up_for_test(database)
    unless @dirty
      database.truncate_table(@schema,@name)
    end
    database.insert_rows(@fixture_rows.insert_statements(@schema,@name))
  end

  def row_count_check(count)
    RowCountExpectation.new(@schema,@name,count)
  end

end

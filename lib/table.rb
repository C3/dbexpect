require 'defaulting_row_set'
require 'expectation_checker'
class Table

  def initialize(schema,name, expectations = DefaultingRowSet.new)
    @schema = schema
    @name = name

    @tdr_rows = DefaultingRowSet.new
    @expectations = expectations
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
    @expectations.set_default(column,value)
    @tdr_rows.set_default(column,value)
  end

  def add_fixture_row(node,column_values)
    @tdr_rows.add_row(node,column_values)
    @fixture_rows.add_row(node,column_values)
  end

  def add_expected_row(node,column_values)
    @expected_rows << @expectations.add_row(node,column_values)
    @tdr_rows.add_row(node,column_values)
    @expected_rows.last
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
  def check_expectations(database)
    @expectation_checker = ExpectationChecker.new(database,@schema,@name)
    @expectation_checker.check_expectations(@expected_rows)
    if @row_count_check
      @expectation_checker.check_row_count(@row_count_check)
    end
  end

  def validates_expectations?
    @expectation_checker.validates_expectations?
  end

  def failed_expectations
    @expectation_checker.failed_expectations
  end

end

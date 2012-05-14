require 'db_sequence'
require 'db_null'
require 'db_string'
require 'table'
require 'd_s_l_parser'
require 'expectation_checker'
require 'console_formatter'

class TestDataGenerator

  def initialize(output = STDOUT)
    @output = ConsoleFormatter.new(output)
  end

  def generate_data(script)
    eval_script(script)
    print_tdr_inserts
    return 0
  end

  def great_expectations(script, target_db)
    eval_script(script)

    check_table_expectations(target_db)

    if validates_expectations?
      @output.notify_passed
      return 0
    else
      @output.notify_failed(failed_expectations)
      return 1
    end
  end

  def setup_test(script,target_db)
    eval_script(script)
    @tables.each do |table|
      table.set_up_for_test(target_db)
    end
    return 0
  end


protected
  def eval_script(script)
    parser = DSLParser.new
    parser.parse(script)
    @tables = parser.tables
    @expectation_tree = parser.expectation_tree
  end

  def print_tdr_inserts
    @tables.each do |table|
      @output.format_sql(table.tdr_insert_stmt)
    end
  end

  def check_table_expectations(database)
    @expectation_checker = ExpectationChecker.new(database)
    @expectation_checker.check_expectations(@expectation_tree)
  end

  def failed_expectations
    @expectation_checker.failed_expectations
  end

  def validates_expectations?
    @expectation_checker.validates_expectations?
  end

end


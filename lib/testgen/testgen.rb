require_relative 'db_sequence'
require_relative 'db_null'
require_relative 'db_string'
require_relative 'table'
require_relative 'd_s_l_parser'
require_relative 'expectation_checker'
require_relative 'console_formatter'

class TestGen

  def initialize(output = STDOUT)
    @output = ConsoleFormatter.new(output)
  end

  def run_test(script,db)
    setup_test(script,db)
    great_expectations(script,db)
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
    parser.parse(File.read(script))
    @tables = parser.tables
    @expectation_tree = parser.expectation_tree
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

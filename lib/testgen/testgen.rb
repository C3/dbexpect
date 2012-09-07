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

  def run_test(script,databases,command_runner)
    setup_test(script,databases)
    run_etl(script,command_runner)
    great_expectations(script,databases)
  end

  def great_expectations(script, databases)
    eval_script(script)

    check_table_expectations(databases)

    if validates_expectations?
      @output.notify_passed
      return 0
    else
      @output.notify_failed(failed_expectations)
      return 1
    end
  end

  def setup_test(script,databases)
    eval_script(script)
    @tables.each do |table|
      table.set_up_for_test(databases)
    end
    return 0
  end


protected
  def run_etl(script,command_runner)
    @commands_to_run.each {|c| command_runner.run(c) }
  end

  def eval_script(script)
    parser = DSLParser.new
    parser.parse(File.read(script))
    @tables = parser.tables
    @expectation_tree = parser.expectation_tree
    @commands_to_run = parser.commands
  end

  def check_table_expectations(databases)
    @expectation_checker = ExpectationChecker.new(databases)
    @expectation_checker.check_expectations(@expectation_tree)
  end

  def failed_expectations
    @expectation_checker.failed_expectations
  end

  def validates_expectations?
    @expectation_checker.validates_expectations?
  end

end


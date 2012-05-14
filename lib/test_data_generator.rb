require 'db_sequence'
require 'db_null'
require 'db_string'
require 'table'
require 'd_s_l_parser'
require 'expectation_checker'

class TestDataGenerator

  def initialize(output = STDOUT)
    @output = output
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
      @output.puts "Passed all expectations\n"
      return 0
    else
      @output.puts failed_expectations.join("\n")
      @output.puts "Failed to meet expectations\n"
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
    @expectations_tree = parser.expected_rows_tree
  end

  def print_tdr_inserts
    @tables.each do |table|
      @output.puts table.tdr_insert_stmt
    end
  end

  def check_table_expectations(database)
    @expectations_checker = ExpectationChecker.new(database)
    all_expectations = @expectations_tree.to_a + @tables.map(&:table_expectations).flatten
    @expectations_checker.check_expectations(all_expectations)
  end

  def failed_expectations
    @expectations_checker.failed_expectations
  end

  def validates_expectations?
    @expectations_checker.validates_expectations?
  end

end


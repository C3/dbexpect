require 'db_sequence'
require 'db_null'
require 'db_string'
require 'table'
require 'd_s_l_parser'

class TestDataGenerator

  def initialize(target_dsn, output = STDOUT)
    @target_dsn = target_dsn
    @output = output
  end

  def generate_data(script)
    eval_script(script)
    print_tdr_inserts
    return 0
  end

  def great_expectations(script, target_db = TargetDatabase.from_dsn(@target_dsn))
    eval_script(script)

    check_table_expectations(target_db)

    if validates_expectations?
      @output.puts "Passed all expectations\n"
      return 0
    else
      @output.puts "Failed to meet expectations\n"
      return 1
    end
  end


protected
  def eval_script(script)
    parser = DSLParser.new
    parser.parse(script)
    @tables = parser.tables
  end

  def print_tdr_inserts
    @tables.each do |table|
      @output.puts table.tdr_insert_stmt
    end
  end

  def check_table_expectations(database)
    @tables.map {|t| t.check_expectations(database) }
  end

  def validates_expectations?
    @tables.all? {|t| t.validates_expectations? }
  end

end


require 'db_sequence'
require 'db_null'
require 'db_string'
require 'table'
require 'd_s_l_parser'

class TestDataGenerator

  def eval_script(script)
    parser = DSLParser.new
    parser.parse(script)
    @tables = parser.tables
  end

  def print_inserts(printer = STDOUT)
    @tables.each do |table|
      printer.puts table.insert_stmt
    end
  end

end


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

  def print_tdr_inserts(printer = STDOUT)
    @tables.each do |table|
      printer.puts table.tdr_insert_stmt
    end
  end

  def validates_expectations?(database)
    @tables.all? {|t| t.validates_expectations?(database) }
  end

end


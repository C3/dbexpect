require 'db_sequence'
require 'db_null'
require 'db_string'
require 'table'
class TestDataGenerator
  def initialize
    @tables = {}
    @universal_defaults = {}
  end

  def eval_script(script)
    instance_eval(script)
  end

  def print_inserts(printer = STDOUT)
    @tables.values.each do |table|
      printer.puts table.insert_stmt
    end
  end

protected
  def requires(file)
    instance_eval(File.read(file))
  end

  def defaults_for(table, columns)
    columns.each do |col, value|
      table.set_default(col,wrap(value))
    end
  end

  def insert_into(table,row_columns,rows)
    rows.each do |row_values|
      wrapped = row_values.map {|v| wrap(v) }
      table.add_row(Hash[ row_columns.zip(wrapped)])
    end
  end

  def all_tables(col_values)
    col_values.each do |col,value|
      @tables.each {|x,t| t.set_default(col, wrap(value)) }
    end
  end

  def table(schema,tablename)
    @tables[schema.to_s + tablename.to_s] ||= Table.new(schema,tablename)
  end

  NULL = DbNull.new
  def null; DbNull.new; end

  def wrap(val)
    case val
    when DbSequence
      val
    when DbNull
      val
    when nil
      NULL
    else
      DbString.new(val)
    end
  end
end


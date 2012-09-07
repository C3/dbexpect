require_relative 'expectation_tree_node'
require 'set'

class DSLParser

  attr_accessor :commands

  def initialize
    @tables = {}
    @tree_nodes = [ExpectationTreeNode.new('->')]
    @files_loaded = Set.new
    @commands = []
  end

  def expectation_tree
    @tree_nodes.first
  end

  def parse(script)
    instance_eval(script)
  end

  def tables
    @tables.values
  end

protected
  def requires(file)
    unless @files_loaded.include?(file)
      instance_eval(File.read(file))
    end
    @files_loaded << file
  end

  def etl_run_command(command)
    @commands << command
  end

  def dirty(table)
    table.dirty = true
  end

  def expect_total_rows(table, count)
    @tree_nodes.last.add([table.row_count_check(count)])
  end

  def describe(description,&block)
    new_node = @tree_nodes.last.create_child(description)
    @tree_nodes << new_node
    instance_eval(&block)
    @tree_nodes.pop
  end

  def defaults_for(table, columns)
    __set_defaults(table,:set_default,columns)
  end

  def expected_defaults(table, columns)
    __set_defaults(table,:set_expected_default,columns)
  end

  def __set_defaults(table, method, columns)
    columns.each do |col, value|
      table.send(method, col, wrap(value))
    end
  end

  def insert_into(table,row_columns,rows)
    __add_rows(table, :add_fixture_row, row_columns, rows)
  end

  def expect_rows(table, row_columns, rows)
    @tree_nodes.last.add __add_rows(table, :add_expected_row, row_columns, rows)
  end

  def __add_rows(table, row_method, row_columns, rows)
    rows.collect do |row_values|
      wrapped = row_values.map {|v| wrap(v) }
      table.send(row_method,Hash[ row_columns.zip(wrapped)])
    end
  end

  def all_tables(col_values)
    col_values.each do |col,value|
      @tables.each {|x,t| t.set_default(col, wrap(value)) }
    end
  end

  def table(db_name,schema,tablename)
    @tables[db_name.to_s + schema.to_s + tablename.to_s] ||= Table.new(db_name,schema,tablename)
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

require 'tree_node'
class DSLParser
  def initialize
    @tables = {}
    @description_tree = TreeNode.new('->')
  end

  def parse(script)
    instance_eval(script)
  end

  def tables
    @tables.values
  end

protected
  def requires(file)
    instance_eval(File.read(file))
  end

  def describe(description,&block)
    @description_tree = @description_tree.create_child(description)
    instance_eval(&block)
    @description_tree = @description_tree.parent
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
    __add_rows(table, :add_row, row_columns, rows)
  end

  def expect_rows(table, row_columns, rows)
    __add_rows(table, :add_expected_row, row_columns, rows)
  end

  def __add_rows(table, row_method, row_columns, rows)
    rows.each do |row_values|
      wrapped = row_values.map {|v| wrap(v) }
      table.send(row_method,@description_tree,Hash[ row_columns.zip(wrapped)])
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

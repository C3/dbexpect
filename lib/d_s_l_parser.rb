class DSLParser
  def initialize
    @tables = {}
    @description_stack = []
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
    @description_stack << description
    instance_eval(&block)
    @description_stack.pop
  end

  def defaults_for(table, columns)
    columns.each do |col, value|
      table.set_default(col,wrap(value))
    end
  end
  alias_method :expected_defaults, :defaults_for

  def insert_into(table,row_columns,rows)
    rows.each do |row_values|
      wrapped = row_values.map {|v| wrap(v) }
      table.add_row(Hash[ row_columns.zip(wrapped)])
    end
  end
  alias_method :expect_rows, :insert_into

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

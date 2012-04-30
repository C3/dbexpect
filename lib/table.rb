class Table
  def initialize(schema,name)
    @schema = schema
    @name = name
    @defaults = Hash.new
    @rows = []
  end

  def set_default(column,value)
    @defaults[column] = value
  end

  def add_row(column_values)
    create_missing_defaults(column_values.keys)
    @rows << @defaults.merge(column_values)
  end

  def insert_stmt
    return '' if @rows.empty?

    stmt = <<SQL
INSERT INTO #{@schema}.#{@name} (#{@defaults.keys.join(',')})
VALUES #{@rows.map {|r| row_values(r) }.join(",\n") };
SQL
  end

protected
  def row_values(row)
    values = @defaults.merge(row)
    '(' + @defaults.keys.map {|col| values[col].db_str }.join(',') + ')'
  end

  def create_missing_defaults(columns)
    columns.each {|c| @defaults[c] ||= DbNull.new }
  end

end

class DefaultingRowSet
  attr_accessor :rows

  def initialize
    @defaults = Hash.new
    @rows = []

    @columns_in_order = []
  end

  def set_default(column,value)
    add_column(column)
    @defaults[column] = value
  end

  def add_row(column_values)
    column_values.keys.map {|col| add_column(col) }

    create_missing_defaults(column_values.keys)
    @rows << set_defaults_at_time_of_addition(column_values)
  end

  def columns
    @columns_in_order.join(',')
  end

  def values
    @rows.map {|r| row_values(r) }.join(",\n") 
  end

  def where_clauses
    @rows.map do |r|
      values = @defaults.merge(r)
      values.map {|col,value| "#{col} #{value.equality_test}" }.join(' AND ')
    end
  end

  def empty?
    @rows.empty?
  end

protected
  def add_column(column)
    @columns_in_order << column
    @columns_in_order.uniq!
  end

  def set_defaults_at_time_of_addition(row)
    @defaults.merge(row)
  end

  def row_values(row)
    values = @defaults.merge(row)
    '(' + @columns_in_order.map {|col| values[col].db_str }.join(',') + ')'
  end

  def create_missing_defaults(columns)
    columns.each {|c| @defaults[c] ||= DbNull.new }
  end

end

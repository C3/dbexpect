class DefaultingRowSet
  attr_accessor :rows

  def initialize
    @defaults = Hash.new
    @rows = []
  end

  def set_default(column,value)
    @defaults[column] = value
  end

  def add_row(column_values)
    create_missing_defaults(column_values.keys)
    @rows << set_defaults_at_time_of_addition(column_values)
  end

  def columns
    @defaults.keys.join(',')
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
  def set_defaults_at_time_of_addition(row)
    @defaults.merge(row)
  end

  def row_values(row)
    values = @defaults.merge(row)
    '(' + @defaults.keys.map {|col| values[col].db_str }.join(',') + ')'
  end

  def create_missing_defaults(columns)
    columns.each {|c| @defaults[c] ||= DbNull.new }
  end

end

require 'row'
class DefaultingRowSet
  attr_accessor :defaults
  attr_accessor :columns_in_order

  def initialize
    @defaults = Hash.new
    @rows = []

    @columns_in_order = []
  end

  def set_default(column,value)
    add_column(column)
    @defaults[column] = value
  end

  def add_row(node,column_values)
    column_values.keys.map {|col| add_column(col) }

    create_missing_defaults(column_values.keys)
    @rows << Row.new(node,set_defaults_at_time_of_addition(column_values),self)
    @rows.last
  end

  def columns
    @columns_in_order.join(',')
  end

  def values
    @rows.map {|r| r.row_values }.join(",\n") 
  end

  def where_clauses
    @rows.map(&:where_clause)
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

  def create_missing_defaults(columns)
    columns.each {|c| @defaults[c] ||= DbNull.new }
  end

end

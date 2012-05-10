require 'row'
class DefaultingRowSet
  attr_accessor :defaults
  attr_accessor :columns_in_order
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

  def add_row(node,column_values)
    column_values.keys.map {|col| add_column(col) }

    defaulted_row = set_defaults_at_time_of_addition(column_values)
    @rows << Row.new(node,defaulted_row,@columns_in_order & defaulted_row.keys)
    @rows.last
  end

  def insert_statements(schema,name)
    @rows.collect do |row|
      row.insert_stmt(schema,name)
    end
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


end

class Row
  attr_accessor :row
  def initialize(node,row,column_order)
    @node = node
    @row = row
    @column_order = column_order
  end

  def row_values
    '(' + @column_order.map {|col| row[col].db_str }.join(',') + ')'
  end

  def where_clause
    @column_order.map {|col| "#{col} #{row[col].equality_test}" }.join(' AND ')
  end

  def columns
    @column_order.join(',')
  end

end

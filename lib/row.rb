class Row
  attr_accessor :row
  def initialize(node,row,defaults_src)
    @node = node
    @row = row
    @defaults_src = defaults_src
  end

  def row_values(column_order)
    values = @defaults_src.defaults.merge(row)
    '(' + column_order.map {|col| values[col].db_str }.join(',') + ')'
  end

  def where_clause
    @defaults_src.defaults.merge(row).map {|col, value| "#{col} #{value.equality_test}" }.join(' AND ')
  end
end

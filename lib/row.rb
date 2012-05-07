class Row
  attr_accessor :row
  def initialize(node,row,defaults_src)
    @node = node
    @row = row
    @defaults_src = defaults_src
  end

  def row_values
    values = @defaults_src.defaults.merge(row)
    '(' + columns_in_order.map {|col| values[col].db_str }.join(',') + ')'
  end

  def where_clause
    @defaults_src.defaults.merge(row).map {|col, value| "#{col} #{value.equality_test}" }.join(' AND ')
  end

  def columns_in_order
    @defaults_src.columns_in_order
  end

end

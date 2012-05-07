class Row
  attr_accessor :row
  def initialize(node,row,defaults_src)
    @node = node
    @row = row
    @defaults_src = defaults_src
  end


  def where_clause
    @defaults_src.defaults.merge(row).map {|col, value| "#{col} #{value.equality_test}" }.join(' AND ')
  end
end

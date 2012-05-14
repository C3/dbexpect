class RowTreeNode

  def initialize(desc, parent = nil)
    @description = desc
    @children = []
    @parent = parent
    @rows = []
  end

  def parent
    raise "Should not happen" if @parent.nil?
    @parent
  end

  def create_child(desc)
    @children << RowTreeNode.new(desc,self)
    @children.last
  end

  def add(rows)
    @rows += rows
  end

end

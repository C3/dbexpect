class RowTreeNode
  include Enumerable

  def initialize(desc, parent = nil)
    @description = desc
    @children = []
    @parent = parent
    @rows = []
  end

  def each(&block)
    @rows.each {|r| block.call(r) }
    @children.each {|c| c.each(&block) }
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

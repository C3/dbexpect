class ExpectationTreeNode
  include Enumerable

  attr_accessor :expectations
  attr_accessor :description
  def initialize(desc, parent = nil)
    @description = desc
    @children = []
    @parent = parent
    @expectations = []
  end

  def each(&block)
    block.call(self)
    @children.each {|c| c.each(&block) }
  end

  def parent
    raise "Should not happen" if @parent.nil?
    @parent
  end

  def create_child(desc)
    @children << ExpectationTreeNode.new(desc,self)
    @children.last
  end

  def add(expectations)
    @expectations += expectations
  end

end

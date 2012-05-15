class ExpectationTreeNode
  include Enumerable

  def initialize(desc,children = [], expectations = [])
    @description = desc
    @children = children
    @expectations = expectations
  end

  def each(&block)
    @expectations.map(&block)
    @children.each {|c| c.each(&block) }
  end

  def select(&block)
    matching_children = @children.collect {|c| c.select(&block) }.
      reject {|node| node === EmptyTreeNode }

    matching_expectations = @expectations.select(&block)

    return EmptyTreeNode.new if matching_children.empty? && matching_expectations.empty?

    ExpectationTreeNode.new(@description,matching_children,matching_expectations)
  end

  def create_child(desc)
    @children << ExpectationTreeNode.new(desc)
    @children.last
  end

  def add(expectations)
    @expectations += expectations
  end

  def empty?
    @expectations.empty? && @children.all?(&:empty?)
  end

  def traverse(depth = 0, &block)
    block.call(depth,@description,@expectations)
    @children.map {|c| c.traverse(depth + 1, &block) }
  end

  class EmptyTreeNode
    include Enumerable
    def each(&block); end
    def empty?; true; end
  end
end

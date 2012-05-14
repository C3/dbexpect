class ExpectationTreeNode
  include Enumerable

  attr_accessor :expectations
  attr_accessor :description
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

  class EmptyTreeNode
    include Enumerable
    def each(&block); end
  end
end

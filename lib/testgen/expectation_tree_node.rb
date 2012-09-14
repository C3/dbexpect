# Copyright 2012 C3 Business Solutions
#
#    This file is part of Testgen.
#
#    Testgen is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    Testgen is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with Testgen.  If not, see <http://www.gnu.org/licenses/>.
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
    def traverse(depth = 0, &block)
    end
  end
end

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
class Row
  attr_accessor :row
  def initialize(row,column_order)
    @row = row
    @column_order = column_order
  end

  def insert_stmt(schema,name)
      stmt = <<SQL
INSERT INTO #{schema}.#{name} (#{columns})
VALUES #{row_values}
SQL
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

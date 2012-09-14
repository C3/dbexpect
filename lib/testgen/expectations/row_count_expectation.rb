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
require_relative 'expectation'
class RowCountExpectation < Expectation
  def initialize(db_name,schema,table,count)
    @count = count
    super(db_name,schema,table)
  end

  def where_clause
    "1=1"
  end

  def expect_msg
    "Expected #{@schema}.#{@table} to contain #{@count} rows, "
  end

end

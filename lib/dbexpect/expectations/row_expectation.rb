# Copyright 2012 C3 Products
#
#    This file is part of dbexpect.
#
#    dbexpect is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    dbexpect is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with dbexpect.  If not, see <http://www.gnu.org/licenses/>.
require_relative 'expectation'
class RowExpectation < Expectation
  def initialize(db_name,schema,table,row_data)
    @row = row_data
    @count = 1
    super(db_name,schema,table)
  end

  def where_clause
    @row.where_clause
  end

  def expect_msg
    "Expected #{@schema}.#{@table} to contain a row where #{where_clause}, "
  end
end

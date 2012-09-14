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
class Expectation
  def initialize(db_name,schema,table)
    @schema = schema
    @table = table
    @db_name = db_name
  end

  def validate_expectation(databases)
    database = databases[@db_name]
    begin
      num = database.num_rows_match(@schema,@table,where_clause)
    rescue OdbcConnection::DatabaseException => e
      @failure = expect_msg + "instead database raised error: #{e.message}"
      return
    end

    if num != @count
      @failure = expect_msg + "got #{num}"
    end
  end

  def failed_validation?
    @failure
  end

  def failure_message
    @failure
  end
end

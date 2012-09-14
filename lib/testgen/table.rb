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
require_relative 'defaulting_row_set'
require_relative 'expectation_checker'
require_relative 'expectations/row_count_expectation'
require_relative 'expectations/row_expectation'

class Table

  def initialize(db_name,schema,name)
    @schema = schema
    @name = name
    @db_name = db_name

    @expected_row_factory = DefaultingRowSet.new
    @fixture_rows = DefaultingRowSet.new

    @dirty = false
  end

  def set_default(column,value)
    @fixture_rows.set_default(column, value)
  end

  def set_expected_default(column,value)
    @expected_row_factory.set_default(column,value)
  end

  def add_fixture_row(column_values)
    @fixture_rows.add_row(column_values)
  end

  def add_expected_row(column_values)
    new_expectation(@expected_row_factory.add_row(column_values))
  end

  def new_expectation(row)
    RowExpectation.new(@db_name,@schema,@name,row)
  end

  attr_writer :dirty
  def set_up_for_test(databases)
    database = databases[@db_name]

    raise "Could not find #{@db_name} in #{databases.inspect}" unless database

    unless @dirty
      database.truncate_table(@schema,@name)
    end
    database.insert_rows(@fixture_rows.insert_statements(@schema,@name))
  end

  def row_count_check(count)
    RowCountExpectation.new(@db_name,@schema,@name,count)
  end

end

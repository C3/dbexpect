# Copyright 2012 C3 Business Solutions
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
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe DefaultingRowSet do
  before :each do
    @it = DefaultingRowSet.new
  end

  describe "generating insert statements" do
    it "should output column/values in the order they were added" do
      @it.set_default(:columnZ,"hello")
      @it.set_default(:column5,"hello")
      @it.set_default(:columnA,"hello")

      @it.add_row(
        :column01 => 'new',
        :columnZ => 'not hello')

      @it.rows.first.columns.should == 'columnZ,column5,columnA,column01'
    end
  end
end

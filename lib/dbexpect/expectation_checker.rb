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
class ExpectationChecker
  attr_accessor :failed_expectations
  def initialize(databases)
    @databases = databases
  end

  def check_expectations(expectations)
    expectations.map {|e| e.validate_expectation(@databases) }

    @failed_expectations = expectations.select {|e| e.failed_validation? }
  end

  def validates_expectations?
    @failed_expectations.empty?
  end
end

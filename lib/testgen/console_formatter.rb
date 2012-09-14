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
class ConsoleFormatter
  def initialize(output)
    @output = output
  end

  def notify_passed
    @output.puts "Passed all expectations\n"
  end

  def notify_failed(failed_expectations)
    failed_expectations.traverse do |depth, description, expectations|
      @output.puts(('  ' * depth) + description + ":\n")

      expectations.collect(&:failure_message).each do |msg|
        @output.puts(('  ' * depth) + ' ' + msg + "\n")
      end
    end
    @output.puts "Failed to meet expectations\n"
  end

  def format_sql(sql)
    @output.puts sql
  end
end

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
class DbSequence
  def initialize
    @sequence = 0
  end

  def db_str
    @sequence += 1
    @sequence.to_s
  end
end

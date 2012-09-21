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
require 'rubygems'
require 'yaml'
require 'odbc'

class OdbcConnection
  class DatabaseException < Exception; end

  attr_accessor :type
  def initialize(dsn,db_config)
    @connection = ODBC.connect(
      dsn,
      db_config['username'],
      db_config['password']
    )

    @type = db_config['type']
  end

  def run(stmt)
    return [] if stmt.empty?
    begin
      query = @connection.run(stmt)
      res = query.to_a
      query.drop
    rescue ODBC::Error => e
      raise DatabaseException.new(e.message)
    end
    res
  end

end

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

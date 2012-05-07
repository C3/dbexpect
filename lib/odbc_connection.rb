require 'rubygems'
require 'yaml'
require 'odbc'

class OdbcConnection
  class DatabaseException < Exception; end

  def initialize(dsn)
    db_config = YAML.load_file('database.yml')[dsn]

    @connection = ODBC.connect(
      dsn,
      db_config['username'],
      db_config['password']
    )
  end

  def run(stmt)
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

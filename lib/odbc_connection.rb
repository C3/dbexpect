require 'rubygems'
require 'yaml'
require 'odbc'

class OdbcConnection
  def initialize(dsn)
    db_config = YAML.load_file('database.yml')[dsn]

    @connection = ODBC.connect(
      dsn,
      db_config['username'],
      db_config['password']
    )
  end

  def run(stmt)
    query = @connection.run(stmt)
    res = query.to_a
    query.drop
    res
  end
end

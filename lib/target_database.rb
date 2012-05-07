require 'odbc_connection'

class TargetDatabase
  def self.from_dsn(dsn)
    new(OdbcConnection.new(dsn))
  end

  def self.from_connection(con)
    new(con)
  end

  def initialize(con)
    @connection = con
  end

  def num_rows_match(query)
    @connection.run(query).count
  end

  def close
    #@connection.close
  end

end

class TargetDatabase
  def self.from_dsn(dsn)

  end

  def self.from_connection(con)
    new(con)
  end

  def initialize(con)
    @connection = con
  end

  def num_rows_match?(query)
    @connection.exec(query).count
  end
end

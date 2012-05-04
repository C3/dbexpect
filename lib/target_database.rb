class TargetDatabase
  def self.from_dsn(dsn)

  end

  def self.from_connection(con)
    new(con)
  end

  def initialize(con)
    @connection = con
  end

  def returns_one_row?(query)
    @connection.exec(query).count == 1
  end
end

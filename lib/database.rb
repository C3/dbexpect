require 'odbc_connection'

class Database
  def self.from_dsn(dsn)
    new(OdbcConnection.new(dsn))
  end

  def self.from_connection(con)
    new(con)
  end

  def initialize(con)
    @connection = con
  end

  def num_rows_match(schema,table,query)
    @connection.run("select * from #{schema}.#{table} where (#{query})").count
  end

  def truncate_table(schema,name)
    if @connection.type == 'db2'
      @connection.run("truncate table #{schema}.#{name} immediate")
    else
      @connection.run("truncate table #{schema}.#{name}")
    end
  end

  def insert_rows(insert_statements)
    @connection.run(insert_statements)
  end

  def close
    #@connection.close
  end

end

require_relative 'odbc_connection'

class Database
  def self.from_connection(con)
    new(con)
  end

  def self.hash_from_config
    databases = {}
    YAML.load_file('database.yml').each do |(dsn,config)|
      databases[dsn.to_sym] = from_connection(OdbcConnection.new(dsn,config))
    end

    databases
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
    insert_statements.each do |stmt|
      @connection.run(stmt)
    end
  end

  def close
    #@connection.close
  end

end

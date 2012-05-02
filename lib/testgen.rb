require 'test_data_generator'
require 'odbc'

class TestGen
  def generate_data(script)
    tg = TestDataGenerator.new
    tg.eval_script(script)
    tg.print_tdr_inserts
  end

  def great_expectations(dsn,script)
    tg = TestDataGenerator.new
    tg.eval_script(script)
    tg.validate_epectations?(ODBC.connect(dsn))
  end
end

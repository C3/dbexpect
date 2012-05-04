require 'test_data_generator'
require 'target_database'

class TestGen
  def generate_data(script)
    tg = TestDataGenerator.new
    tg.eval_script(script)
    tg.print_tdr_inserts
  end

  def great_expectations(dsn,script)
    tg = TestDataGenerator.new
    tg.eval_script(script)

    if tg.validate_epectations?(TargetDatabse.from_dsn(dsn))
      puts "Failed to meet expectations\n"
    else
      puts "Passed all expectations\n"
    end

  end
end

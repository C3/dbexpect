require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'pg'

describe "TestGen" do
  before :each do
    @db = PG.connect(:dbname => 'testgen', :port => 5433)
    @db.exec(File.read('spec/fixtures/sample_db.sql'))

    @output = StringIO.new

    @test_script = File.read('spec/fixtures/basic_test_defn.rb')

    @it = TestDataGenerator.new(@output)

  end

  after :each do
    @db.exec(File.read('spec/fixtures/cleanup_db.sql'))
    @db.close
  end

  describe "generating inserts for a TDR from scripts" do
    before :each do
      @it.generate_data(@test_script)
      @output.rewind
    end

    it "should output what we expect" do
      @db.exec(@output.read)

      @db.exec('select * from source.src_table').values.should ==
        [
          ["default string", "7", nil],
          ["overridden string", "1", "not null"] ]

      @db.exec('select * from target.tgt_table').values.should ==
        [
         ["defaulted in script", "1", nil],
         ["defaulted in script", "2", nil],
         ["defaulted in script", "3", nil],
         ["defaulted in script", "4", "4"],
         ["special row", "5", "6"]]
    end
  end

  describe "validating expectations" do
    before :each do
      @target_db = TargetDatabase.from_connection(@db)

      @it.generate_data(@test_script)
      @output.rewind
      @some_inserts = @output.read
    end

    it "should fail if zero expected rows exist" do
      @it.great_expectations(@test_script,@target_db).should == 1
    end

    it "should pass if exactly correct" do
      @db.exec(@some_inserts)
      @it.great_expectations(@test_script,@target_db).should == 0
    end

    it "should whine if more rows than we want" do
      @db.exec(@some_inserts)
      @db.exec(@some_inserts)
      @it.great_expectations(@test_script,@target_db).should == 1
    end

  end
end

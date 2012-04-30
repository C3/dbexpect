require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'pg'

describe "TestGen" do
  before :each do
    @it = TestDataGenerator.new
    @db = PG.connect(:dbname => 'testgen', :port => 5433)
    @db.exec(File.read('spec/fixtures/sample_db.sql'))
  end

  after :each do
    @db.exec(File.read('spec/fixtures/cleanup_db.sql'))
    @db.close
  end

  describe "generating test data from scripts" do
    it "should output what we expect" do
      @it.eval_script(
        File.read('spec/fixtures/basic_test_defn.rb')
      )

      output = StringIO.new
      @it.print_inserts(output)
      output.rewind

      @db.exec(output.read)

      @db.exec('select * from source.src_table').values.should ==
        [
          ["default string", "7", nil],
          ["overridden string", "1", "not null"] ]

      @db.exec('select * from target.tgt_table').values.should ==
        [
         ["defaulted in script", "5", nil],
         ["defaulted in script", "5", nil],
         ["defaulted in script", "5", nil],
         ["defaulted in script", "5", "4"] ]
    end
  end
end

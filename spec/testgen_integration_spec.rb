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

      puts @db.select_all('select * from source.src_table').inspect
      puts @db.select_all('select * from target.tgt_table').inspect
    end
  end
end

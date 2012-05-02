require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'pg'

describe "TestGen" do
  before :each do
    @it = TestDataGenerator.new
    @db = PG.connect(:dbname => 'testgen', :port => 5433)
    @db.exec(File.read('spec/fixtures/sample_db.sql'))

    @it.eval_script(
      File.read('spec/fixtures/basic_test_defn.rb')
    )

    @output = StringIO.new
    @it.print_tdr_inserts(@output)
    @output.rewind

  end

  after :each do
    @db.exec(File.read('spec/fixtures/cleanup_db.sql'))
    @db.close
  end

  describe "generating inserts for a TDR from scripts" do
    it "should output what we expect" do
      @db.exec(@output.read)

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

  describe "validating expectations" do
    it "should fail if zero expected rows exist" do
      @it.validates_expectations?(@db).should == false
    end

    it "should pass if exactly correct" do
      @db.exec(@output.read)
      @it.validates_expectations?(@db).should == true
    end

    it "should whine if more rows than we want" do
      @db.exec(@output.read)
      @output.rewind
      @db.exec(@output.read)
      @it.validates_expectations?(@db).should == false
    end
  end
end

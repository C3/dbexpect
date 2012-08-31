require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'rubygems'
require 'odbc'
require 'pry'
require 'tempfile'

describe "TestGen" do
  before :each do
    @db = OdbcConnection.new('testgen')

    @db.run(File.read('spec/fixtures/sample_db.sql'))

    @output = StringIO.new

    @test_script = 'spec/fixtures/basic_test_defn.rb'
    @test_script2 = 'spec/fixtures/test_script2.rb'

    @it = TestGen.new(@output)
  end

  def tempfile(content)
    f = Tempfile.new('tempfile')
    f.write content
    f.close
    f.path
  end

  after :each do
    @db.run(File.read('spec/fixtures/cleanup_db.sql'))
  end

  describe "running test scripts one after the other" do
    it "should not maintain state across tests" do

      @it.generate_data(@test_script2)
      @output.rewind
      @it.generate_data(@test_script)
      @output.rewind
      @output.read.should_not =~ /test_script2_col/
    end
  end

  describe "generating inserts for a TDR from scripts" do
    before :each do
      @it.generate_data(@test_script)
      @output.rewind
    end

    it "should output what we expect" do
      @db.run(@output.read)

      @db.run('select * from source.src_table').to_a.should ==
        [
          ["default string", 7, nil],
          ["overridden string", 1, "not null"] ]

      @db.run('select * from target.tgt_table').to_a.should ==
        [
         ["defaulted in script", 1, nil],
         ["defaulted in script", 2, nil],
         ["defaulted in script", 3, nil],
         ["defaulted in script", 4, 4],
         ["special row", 5, 6]]
    end
  end

  describe "setting up a database for a test" do
    before :each do
      @target_db = Database.from_connection(@db)
      @it.generate_data(@test_script)
      @output.rewind
      @db.run(@output.read)

      @it.setup_test(@test_script,@target_db)
    end

    it "should truncate the source tables and add the fixture rows" do

      @db.run('select * from source.src_table').to_a.should ==
        [
          ["default string", 7, nil],
          ["overridden string", 1, "not null"] ]
    end

    it "should truncate the expected rows tables" do
      @db.run('select * from target.tgt_table').to_a.should ==
        []
    end
  end

  describe "validating expectations" do
    before :each do
      @target_db = Database.from_connection(@db)

      @it.generate_data(@test_script)
      @output.rewind
      @some_inserts = @output.read
    end

    it "should fail if zero expected rows exist" do
      @output.rewind
      @it.great_expectations(@test_script,@target_db).should == 1
      @output.rewind
      @output.read.should == File.read('spec/fixtures/expected_output.txt')
    end

    it "should pass if exactly correct" do
      @db.run(@some_inserts)
      @it.great_expectations(@test_script,@target_db).should == 0
    end

    it "should whine if more rows than we want" do
      @db.run(@some_inserts)
      @db.run(@some_inserts)
      @it.great_expectations(@test_script,@target_db).should == 1
    end

    it "should be happy if row counts are correct" do
      @db.run(@some_inserts)
      @it.great_expectations(tempfile("expect_total_rows table(:target,:tgt_table), 5"),
                             @target_db).should == 0
    end

    it "should whine if row counts are off" do
      @db.run(@some_inserts)
      @it.great_expectations(tempfile("expect_total_rows table(:target,:tgt_table), 10"),
                             @target_db).should == 1
    end


  end
end

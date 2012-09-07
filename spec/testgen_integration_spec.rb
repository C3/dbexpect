require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'rubygems'
require 'odbc'
require 'pry'
require 'tempfile'

describe "TestGen" do
  before :each do
    @src_db = OdbcConnection.new('testgen_src')
    @tgt_db = OdbcConnection.new('testgen_tgt')

    @src_db.run(File.read('spec/fixtures/sample_db.sql'))
    @tgt_db.run(File.read('spec/fixtures/sample_db.sql'))

    @databases = {:testgen_src => Database.from_connection(@src_db),
                  :testgen_tgt => Database.from_connection(@tgt_db)}

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
    @tgt_db.run(File.read('spec/fixtures/cleanup_db.sql'))
    @src_db.run(File.read('spec/fixtures/cleanup_db.sql'))
  end

  describe "setting up a database for a test" do
    before :each do
      @it.setup_test(@test_script,@databases)
    end

    it "should truncate the source tables and add the fixture rows" do

      @src_db.run('select * from source.src_table').to_a.should ==
        [
          ["default string", 7, nil],
          ["overridden string", 1, "not null"] ]
    end

    it "should truncate the expected rows tables" do
      @tgt_db.run('select * from target.tgt_table').to_a.should ==
        []
    end
  end

  describe "validating expectations" do
    before :each do
    end

    it "should fail if zero expected rows exist" do
      @output.rewind
      @it.great_expectations(@test_script,@databases).should == 1
      @output.rewind
      @output.read.should == File.read('spec/fixtures/expected_output.txt')
    end

    it "should pass if exactly correct" do
      @tgt_db.run(File.read('spec/fixtures/basic_test_expected_inserts.sql'))
      @it.great_expectations(@test_script,@databases).should == 0
    end

    it "should whine if more rows than we want" do
      @tgt_db.run(File.read('spec/fixtures/basic_test_expected_inserts.sql'))
      @tgt_db.run(File.read('spec/fixtures/basic_test_expected_inserts.sql'))
      @it.great_expectations(@test_script,@databases).should == 1
    end

    it "should be happy if row counts are correct" do
      @tgt_db.run(File.read('spec/fixtures/basic_test_expected_inserts.sql'))
      @it.great_expectations(tempfile("expect_total_rows table(:testgen_tgt,:target,:tgt_table), 5"),
                             @databases).should == 0
    end

    it "should whine if row counts are off" do
      @tgt_db.run(File.read('spec/fixtures/basic_test_expected_inserts.sql'))
      @it.great_expectations(tempfile("expect_total_rows table(:testgen_tgt,:target,:tgt_table), 10"),
                             @databases).should == 1
    end
  end

  describe "both setting up sources and validating expectations" do
    before :each do
      @command_runner = mock("CommandRunner")
      @command_runner.should_receive(:run).once.with("echo 400")
    end

    it "should put data in the database" do
      @it.run_test(@test_script,@databases,@command_runner)
      @src_db.run('select * from source.src_table').to_a.should ==
        [
          ["default string", 7, nil],
          ["overridden string", 1, "not null"] ]
    end

    it "should give us back reasonable pass/fails" do
      @it.run_test(@test_script,@databases,@command_runner).should == 1
      @output.rewind
      @output.read.should == File.read('spec/fixtures/expected_output.txt')
    end

    it "should not hold state between test runs" do
      @it.run_test(@test_script,@databases,@command_runner)
      @it.run_test(tempfile("expect_total_rows table(:testgen_tgt,:target,:tgt_table), 0"),@databases,@command_runner).should == 0
    end
  end
end

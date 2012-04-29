require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "TestGen" do
  before :each do
    @it = TestDataGenerator.new
  end

  describe "catchall integration" do
    it "should output what we expect" do
      @it.eval_script(
        File.read('spec/fixtures/test_sets/accommodation.rb')
      )

      output = StringIO.new
      @it.print_inserts(output)
      output.length.should == 79912
    end
  end
end

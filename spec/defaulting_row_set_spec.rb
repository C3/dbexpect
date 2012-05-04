require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe DefaultingRowSet do
  before :each do
    @it = DefaultingRowSet.new
  end

  describe "generating insert statements" do
    it "should output column/values in the order they were added" do
      @it.set_default(:columnZ,"hello")
      @it.set_default(:column5,"hello")
      @it.set_default(:columnA,"hello")

      @it.add_row(
        :column01 => 'new',
        :columnZ => 'not hello')

      @it.columns.should == 'columnZ,column5,columnA,column01'
    end
  end
end

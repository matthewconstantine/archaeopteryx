# bowling_spec.rb
require 'cfm/cfm'
include CFM

describe Scale do
  before(:each) do
    @major = Scale.new MAJOR
  end

  it "should return the correct number of half steps from tonic" do
    (-6..6).collect {|x| 
      @major[x] }.should == [-10, -8, -7, -5, -3, -1, 0, 2, 4, 5, 7, 9, 11]
  end
  
  it "should return the correct next note" do
    # For a major scale with a tonic of 62(D4) find the next interval for pitch E5
    # keep in mind D4 is assumed to be within the given scale
    @major.next(D4, E5).should == FS5
    @major.next(D4, E5, 3).should == A5
    @major.next(D4, E5, -3).should == B4
  end
  
end


describe Context do
  before(:each) do
    @c = Context.new
  end
  
  it "should have some sensible defaults" do
    @c[:scale].should_not be_nil
    @c[:tonic].should == C4
    @c[:pitch].should == C4
    @c[:beat].should == 1
    @c[:velocity].should == 120
  end
  
  it "should tranform its context" do
    @c.transform(:forward => 5, :up => 5)
    @c[:beat].should == 6
    @c[:pitch].should == A4
    @c.transform(:back => 2)
    @c[:beat].should == 4
  end
  
  it "should survive a nil transform" do
    d = @c.dup.transform({})
    d.should_not be_nil
    d.delete :scale
    d.should == {:pitch=>C4, :beat=>1, :velocity=>120, :tonic=>60}
  end
  
  
end

require 'zerg_xcode'

describe ZergXcode::IdGenerator do

  let(:object_a) do
    o = ZergXcode::XcodeObject.new :foo => 'bar'
    o.archive_id = '49'
    o
  end

  let(:object_b) do
    o = ZergXcode::XcodeObject.new :foo => 'bar'
    o.archive_id = '49'
    o
  end

  context "when given an object with id '49'" do

    it "should return '49'" do
      subject.id_for(object_a).should == '49'
    end

  end

  # This seems a little odd, but is how I found it.  If given the
  # same object twice, it will generate a new ID the second time.
  context "when given a second object with id '49'" do
    before do
      subject.id_for(object_a)
    end

    it "should not return '49'" do
      subject.id_for(object_b).should_not == '49'
    end
  end

end
 

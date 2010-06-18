require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Subj3ct" do
  it "should define the namespace Subj3ct" do
    fail unless defined?(::Subj3ct)
    Subj3ct.should be_a_kind_of Module
  end
  
  it "should define the namespace Subject equivalent to Subj3ct" do
    fail unless defined?(::Subject)
    ::Subject.should be_a_kind_of Module
    ::Subj3ct.should == ::Subject
  end
  
  it "should have the four query methods" do
    Subj3ct.should respond_to :identifier
    Subj3ct.should respond_to :resource
    Subj3ct.should respond_to :starts_with
    Subj3ct.should respond_to :search
  end
  
  describe "identifier" do
    it "should fetch a subject by identifier" do
      sir =  Subj3ct.identifier("http://bock.be/njamin")
      sir.should be_a_kind_of Subj3ct::Query::SubjectIdentityRecord
    end
  end
end

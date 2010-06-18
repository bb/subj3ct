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
  
  describe "resource" do
    it "should fetch one or more subjects by resource" do
      sr =  Subj3ct.resource("http://bock.be/njamin")
      sr.should be_a_kind_of Subj3ct::Query::SearchResult
      sr.size.should >= 1
    end
  end    

  describe "starts_with" do
    it "should fetch one or more subjects by prefix of it's identifier" do
      sr =  Subj3ct.starts_with("bock.be/njamin")
      sr.should be_a_kind_of Subj3ct::Query::SearchResult
      sr.size.should >= 1
    end
  end    

  describe "search" do
    it "should search for keywords" do
      sr =  Subj3ct.search("topic maps")
      sr.should be_a_kind_of Subj3ct::Query::SearchResult
      # there are more than 10000 results now, I don't expect it will become less than 50
      sr.size.should == 50
      sr.total.should > 50
    end
  end    

end

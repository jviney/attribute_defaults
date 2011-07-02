require "spec_helper"

describe "active_record/attribute_defaults" do
  it "should supply defaults for a new record" do
    p = Person.new
    
    p.city.should == "Christchurch"
    p.country.should == "New Zealand"
    p.first_name.should == "Sean"
    p.last_name.should == "Fitzpatrick"
    p.lucky_number.should == 2
    p.favourite_colour.should == "Blue"
  end
  
  it "should ignore the default if a specific value is given" do
    p = Person.new(:city => "", "lucky_number" => nil)
    
    p.city.should == ""
    p.lucky_number.should be_nil
    
    p.country.should == "New Zealand"
    p.first_name.should == "Sean"
    p.last_name.should == "Fitzpatrick"
    p.favourite_colour.should == "Blue"
  end
  
  it "should not cache the result of the default block" do
    one = Person.new
    two = Person.new
    
    one.first_name.object_id.should_not == two.first_name.object_id
  end
  
  it "should not provide defaults for existing records" do
    existing_person = Person.create!(:last_name => "Key")
    Person.find(existing_person.id).last_name.should == "Key"
  end
  
  it "should process the defaults in the order of definition" do
    Person.new(:last_name => "Carter").favourite_colour.should == "Red"
  end
  
  it "should add defaults on create!" do
    p = Person.create!
    
    p.city.should == "Christchurch"
    p.country.should == "New Zealand"
    p.first_name.should == "Sean"
    p.last_name.should == "Fitzpatrick"
    p.lucky_number.should == 2
    p.favourite_colour.should == "Blue"
  end
  
  it "should allow a default object for a belongs_to association" do
    @school = School.create! { |s| s.id = 1 }
    PersonWithDefaultSchool.new.school.should == @school
    @school.destroy
  end
  
  it "should not use the default for a belongs to association when a nil id is supplied" do
    PersonWithDefaultSchool.new(:school_id => nil).school.should be_nil
  end
  
  it "should allow a default id for a belongs_to association" do
    @school = School.create! { |s| s.id = 1 }
    PersonWithDefaultSchoolId.new.school.should == @school
    @school.destroy
  end
  
  it "should ignore a default id for a belongs_to association when an object is supplied" do
    PersonWithDefaultSchoolId.new(:school => nil).school.should be_nil
  end
  
  it "should not raise an error when no defaults are defined" do
    klass = Class.new(ActiveRecord::Base) { set_table_name "people" }
    lambda { klass.new }.should_not raise_error
  end
end

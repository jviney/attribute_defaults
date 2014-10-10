require "spec_helper"

describe "attribute_defaults" do
  it "supplies defaults for a new record" do
    p = Person.new
    
    expect(p.city).to eq "Christchurch"
    expect(p.country).to eq "New Zealand"
    expect(p.first_name).to eq "Sean"
    expect(p.last_name).to eq "Fitzpatrick"
    expect(p.lucky_number).to eq 2
    expect(p.favourite_colour).to eq "Blue"
  end
  
  it "ignores the default if a specific value is given" do
    p = Person.new(:city => "", "lucky_number" => nil)
    
    expect(p.city).to eq ""
    expect(p.lucky_number).to be_nil
    
    expect(p.country).to eq "New Zealand"
    expect(p.first_name).to eq "Sean"
    expect(p.last_name).to eq "Fitzpatrick"
    expect(p.favourite_colour).to eq "Blue"
  end
  
  it "does not cache the result of the default block" do
    one = Person.new
    two = Person.new
    
    expect(one.first_name.object_id).not_to eq two.first_name.object_id
  end
  
  it "does not provide defaults for existing records" do
    existing_person = Person.create!(:last_name => "Key")
    expect(Person.find(existing_person.id).last_name).to eq "Key"
  end
  
  it "processes the defaults in the order of definition" do
    expect(Person.new(last_name: "Carter").favourite_colour).to eq "Red"
  end
  
  it "adds defaults on create!" do
    p = Person.create!
    
    expect(p.city).to eq "Christchurch"
    expect(p.country).to eq "New Zealand"
    expect(p.first_name).to eq "Sean"
    expect(p.last_name).to eq "Fitzpatrick"
    expect(p.lucky_number).to eq 2
    expect(p.favourite_colour).to eq "Blue"
  end
  
  it "allows a default object for a belongs_to association" do
    @school = School.create! { |s| s.id = 1 }
    expect(PersonWithDefaultSchool.new.school).to eq @school
    @school.destroy
  end
  
  it "does not use the default for a belongs to association when a nil id is supplied" do
    expect(PersonWithDefaultSchool.new(school_id: nil).school).to be_nil
  end
  
  it "allows a default id for a belongs_to association" do
    @school = School.create! { |s| s.id = 1 }
    expect(PersonWithDefaultSchoolId.new.school).to eq @school
    @school.destroy
  end
  
  it "ignores a default id for a belongs_to association when an object is supplied" do
    expect(PersonWithDefaultSchoolId.new(school: nil).school).to be_nil
  end
  
  it "does not raise an error when no defaults are defined" do
    klass = Class.new(ActiveRecord::Base) { self.table_name = "people" }
    expect { klass.new }.not_to raise_error
  end
end

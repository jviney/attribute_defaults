require "rubygems"
require "bundler/setup"
require "rspec"

require "active_record"
require "active_record/base"

require File.expand_path("../../lib/attribute_defaults", __FILE__)

ActiveRecord::Base.configurations = YAML::load(IO.read(File.dirname(__FILE__) + "/database.yml"))
ActiveRecord::Base.logger = ActiveSupport::BufferedLogger.new(File.dirname(__FILE__) + "/debug.log")
ActiveRecord::Base.establish_connection(ENV["DB"] || "mysql")

load(File.dirname(__FILE__) + "/schema.rb")

# Fixtures
Address = Struct.new(:suburb, :city)

class Group < ActiveRecord::Base
end

class Person < ActiveRecord::Base
  belongs_to :school
  
  # Include an aggregate reflection to check compatibility
  composed_of :address, :mapping => [%w(address_suburb suburb), %(address_city city)]
  
  defaults :city => "Christchurch", :country => lambda { "New Zealand" }
  
  default :first_name => "Sean"
  
  default :last_name do
    "Fitzpatrick"
  end
  
  defaults :lucky_number => lambda { 2 }, :favourite_colour => :default_favourite_colour
  
  def default_favourite_colour
    last_name == "Fitzpatrick" ? "Blue" : "Red"
  end
end

class PersonWithDefaultSchool < Person
  default :school do
    School.find(1)
  end
end

class PersonWithDefaultSchoolId < Person
  default :school_id => 1
end

class School < ActiveRecord::Base
  has_many :people
end

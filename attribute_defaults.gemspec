require File.expand_path("../lib/active_record/attribute_defaults/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "attribute_defaults"
  s.version     = ActiveRecord::AttributeDefaults::VERSION
  s.summary     = "attribute_defaults-#{s.version}"
  s.description = "Add default attribute values when creating models."
  s.authors     = ["Jonathan Viney"]
  s.email       = "jonathan.viney@gmail.com"
  s.files       = ["lib/**/*.rb"]
  s.homepage    = "http://github.com/jviney/active_record_defaults"
  
  s.add_dependency "activerecord", ">= 3"
  
  s.add_development_dependency "rspec"
end

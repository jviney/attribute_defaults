# Active Record Attribute Defaults

An easy way to specify default attribute values for new records.

## Quick start

    class Person < ActiveRecord::Base
      defaults :country => 'New Zealand', :type => 'Unknown', :address => lambda { Address.new }
  
      default :last_name do |person|
        person.first_name
      end
    end
  
The default value is only used if the attribute is not present in the attributes hash, so any values you pass in when creating the record will take precedence.

Note that the defaults are evaluated when the model class is loaded, so if a default is meant to
be dynamic, such as today's date, it must be specified as a proc.

    class Person < ActiveRecord::Base
      default :today => Date.today            # WRONG
      default :today => lambda { Date.today } # RIGHT
    end
  
Interestingly, because the model classes are reloaded for every request in development mode,
the first default would always work as expected. But in production, where the model classes are
only loaded once, the date will shortly become incorrect.

## More information

Use this gem to define default values for attributes on new records.
Requires a hash of `attribute => value` pairs, or a single attribute with an associated block.

 * If the value is a block, it will be called to retrieve the default value.
 * If the value is a symbol, a method by that name will be called on the object to retrieve the default value.

The following code demonstrates the different ways default values can be specified. Defaults are applied in the order they are defined.

    class Person < ActiveRecord::Base
      defaults :name => "My name", :city => lambda { "My city" }
      
      default :birthdate do |person|
        Date.current if person.wants_birthday_today?
      end
      
      default :favourite_colour => :default_favourite_colour
      
      def default_favourite_colour
        "Blue"
      end
    end

The `defaults` and the `default` methods behave the same way. Use whichever is appropriate.

The default values are only used if the key is not present in the given attributes.
Therefore, the above code will behave in the following way:

    p = Person.new
    p.name # "My name"
    p.city # "My city"
    
    p = Person.new(:name => nil)
    p.name # nil
    p.city # "My city"

### Default values for belongs_to associations

Default values can also be specified for an association. For instance:

    class Student < ActiveRecord::Base
      belongs_to :school
      
      default :school => lambda { School.favourite }
    end

In this scenario, if a `school_id` was provided in the attributes hash, the default value for the association will be ignored:

    s = Student.new
    s.school # => #<School: ...>

    s = Student.new(:school_id => nil)
    s.school # => nil

Similarly, if a default value is specified for the foreign key and an object for the association is provided, the default foreign key is ignored.

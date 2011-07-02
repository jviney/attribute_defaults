module AttributeDefaults
  class Default
    attr_reader :attribute
    
    def initialize(attribute, value)
      @attribute, @value = attribute.to_s, value
    end
    
    def value(record)
      if @value.is_a?(Symbol)
        record.send(@value)
      elsif @value.respond_to?(:call)
        @value.call(record)
      else
        @value.duplicable? ? @value.dup : @value
      end
    end
  end
end

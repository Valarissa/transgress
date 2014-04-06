class Validator
  VALIDATION_REGEXES = [
    /trans/i,
    /tranny/i
  ]
  class << self
    def validate(document)
      VALIDATION_REGEXES.each do |validator|
        return true if document.root.content =~ validator
      end

      false
    end
  end
end

class Validator
  class << self
    def validate(document)
      document.root.content =~ /trans/
    end
  end
end

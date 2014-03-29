class Validator
  class << self
    def validate(page)
      page =~ /trans/
    end
  end
end

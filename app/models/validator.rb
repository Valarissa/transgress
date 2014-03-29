class Validator
  class << self
    def validate(page)
      page.body =~ /trans/
    end
  end
end

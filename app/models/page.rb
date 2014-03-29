class Page
  class << self
    def get_page(url)
      page = Request.get(url)
      validate_page!(page)
    end

    def validate_page!(page)
      return Sanitizer.sanitize(page) if Validator.validate(page)
      page = "This is irrelevant"
    end
  end
end

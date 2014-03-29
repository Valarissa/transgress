class Sanitizer
  class << self
    def sanitize(page)
      page.gsub!(/trans/i, "derp")
    end
  end
end

class Sanitizer
  class << self
    def sanitize(page)
      replace_links(page)
      replace_text(page)
    end

    def replace_links(page)
      page.body.gsub!(/href=["']\/([^"']*)["']/, 'href="/visit/'+page.url_safe_url+'\1"')
    end

    def replace_text(page)
      page.body.gsub!(/trans/i, "derp")
    end
  end
end

class Sanitizer
  class << self
    def sanitize(doc)
      new(doc).sanitize
    end
  end

  def initialize(page)
    self.page = page
    self.doc = page.body
  end

  def sanitize
    replace_anchors
    replace_links
    replace_text
  end

  private
    attr_accessor :doc, :page

    def replace_anchors
      doc.xpath('//a').each do |a|
        a['href'] = a['href'].gsub(/\/([^"']*)/, '/visit/'+page.url_safe_url+'\1')
      end
    end

    def replace_links
      doc.xpath('//link').each do |l|
        l['href'] = l['href'].gsub(/\/([^"']*)/, '/visit/'+page.url_safe_url+'\1')
      end
    end

    def replace_text
      doc.xpath('//text()').each do |text|
        text.content = text.content.gsub(/trans/i, "derp")
      end
    end
end

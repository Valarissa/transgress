require 'nokogiri'

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
    redirect_anchors
    redirect_links
    redirect_images
    redirect_scripts
    replace_text
    append_translator
  end

  private
    attr_accessor :doc, :page

    def replace_element_attribute(element, attribute)
      doc.xpath("//#{element}").each do |tag|
        next unless tag[attribute]
        next if tag[attribute] =~ /:\/\//
        tag[attribute] = tag[attribute].gsub(/^\/(.*)/, '/visit/'+page.url_safe_root+'\1')
        tag[attribute] = tag[attribute].gsub(/^([^\/].*)/, '/visit/'+page.url_safe_url+'\1')
      end
    end

    def redirect_anchors
      replace_element_attribute('a', 'href')
    end

    def redirect_links
      replace_element_attribute('link', 'href')
    end

    def redirect_images
      replace_element_attribute('img', 'src')
    end

    def redirect_scripts
      replace_element_attribute('script', 'src')
    end

    def replace_text
      doc.xpath('//text()').each do |text|
        next if text.parent.name =~ /script/i
        Validator::regexes.each_with_index do |regex, i|
          text.content = text.content.gsub(regex, "~*#{i}*~")
        end
      end
    end

    def append_translator
      jQ = Nokogiri::XML::Node.new('script', doc)
      jQ['src'] = "//code.jquery.com/jquery-1.11.0.min.js"
      doc.xpath('//head')[0].children.first.before(jQ)

      script = Nokogiri::XML::Node.new('script', doc)
      script['src'] = ApplicationController.helpers.asset_path("application.js")
      doc.xpath('//head')[0].children.last.after(script)
    end
end

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
  end

  private
    attr_accessor :doc, :page

    def redirect_anchors
      doc.xpath('//a').each do |a|
        next unless a['href']
        next if a['href'] =~ /:\/\//
        a['href'] = a['href'].gsub(/^\/(.*)/, '/visit/'+page.url_safe_root+'\1')
        a['href'] = a['href'].gsub(/^([^\/].*)/, '/visit/'+page.url_safe_url+'\1')
      end
    end

    def redirect_links
      doc.xpath('//link').each do |l|
        next unless l['href']
        next if l['href'] =~ /:\/\//
        l['href'] = l['href'].gsub(/^\/(.*)/, '/visit/'+page.url_safe_root+'\1')
        l['href'] = l['href'].gsub(/^([^\/].*)/, '/visit/'+page.url_safe_url+'\1')
      end
    end

    def redirect_images
      doc.xpath('//img').each do |i|
        next unless i['src']
        next if i['src'] =~ /:\/\//
        i['src'] = i['src'].gsub(/^\/(.*)/, '/visit/'+page.url_safe_root+'\1')
        i['src'] = i['src'].gsub(/^([^\/].*)/, '/visit/'+page.url_safe_url+'\1')
      end
    end

    def redirect_scripts
      doc.xpath('//script').each do |s|
        next unless s['src']
        next if s['src'] =~ /:\/\//
        s['src'] = s['src'].gsub(/^\/(.*)/, '/visit/'+page.url_safe_root+'\1')
        s['src'] = s['src'].gsub(/^([^\/].*)/, '/visit/'+page.url_safe_url+'\1')
      end
    end

    def replace_text
      doc.xpath('//text()').each do |text|
        next if text.parent.name =~ /script/i
        text.content = text.content.gsub(/trans/i, "~*0*~")
      end
    end
end

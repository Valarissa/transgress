require 'nokogiri'

class Page
  class << self
    attr_accessor
    def get_page(url)
      new(fill_in_url_details(url))
    end

    def fill_in_url_details(url)
      url = "#{url}/" if not url.split('/').last.match(/\./)
      url = "http://#{url}" if not URI.scheme_list[url.split(':').first.upcase]
      url
    end
  end

  attr_reader :host, :body

  def initialize(url)
    self.uri = URI(url)
    self.body = Nokogiri::HTML(Request.get(uri))
    validate!
  end

  def validate!
    if Validator.validate(self.body)
      Sanitizer.sanitize(self)
    else
      self.body = Nokogiri::HTML("<html><head>IRRELEVANT</head><body>This is irrelevant</body></html>")
    end
  end

  def root
    @root ||= "#{uri.scheme}://#{uri.host}"
  end

  def url_safe_root
    URI.escape(root+'/', "/:?&#")
  end

  def current_url
    @url ||= "#{root}#{uri.path}"
  end

  def url_safe_url
    URI.escape(current_url, "/:?&#")
  end

  def full_url
    url = current_url
    url += "?#{uri.query}" if uri.query
    url += "##{uri.fragment}" if uri.fragment
  end

  def to_s
    body.root.to_s
  end

  private
    attr_accessor :uri
    attr_writer :body
end

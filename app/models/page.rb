class Page
  class << self
    attr_accessor
    def get_page(url)
      new(url)
    end

  end

  attr_reader :host, :body

  def initialize(url)
    self.uri = URI(fill_in_url_details(url))
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

    def fill_in_url_details(url)
      uri = URI(url)
      uri = URI(url = "http://#{url}") unless uri.scheme
      uri = URI(url = "#{url}/") if uri.path.empty?
      uri
    end
end

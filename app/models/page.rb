class Page
  class << self
    attr_accessor
    def get_page(url)
      new(URI(url))
    end

  end

  attr_reader :host, :body

  def initialize(uri)
    self.uri = uri
    set_request_defaults
    @body = Request.get(uri)
    validate!
  end

  def validate!
    return Sanitizer.sanitize(self) if Validator.validate(self)
    @body = "This is irrelevant"
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

  private
    attr_accessor :uri

    def set_request_defaults
      self.uri.scheme = "http" unless uri.scheme
    end
end

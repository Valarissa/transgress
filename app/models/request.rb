class Request
  class << self
    def get(url)
      Net::HTTP::get(URI(url))
    end
  end
end

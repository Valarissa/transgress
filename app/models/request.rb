class Request
  class << self
    def get(url)
      resp = Net::HTTP::get_response(URI(url))
      p resp
      case resp
      when Net::HTTPRedirection
        resp = Net::HTTP::get_response(URI(resp["location"]))
      end

      resp.body
    end
  end
end

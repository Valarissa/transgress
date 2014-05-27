class Validator
  class << self
    def validate(document)
      content = document.root.content
      content.encode!('UTF-8', 'UTF-8', :invalid => :replace)
      regexes.each do |validator|
        return true if content =~ validator
      end

      false
    end

    def regexes
      @list ||= parse_json_list
    end

    def parse_json_list
      filename = Rails.root + 'public/assets/string_list.json'
      list = JSON.parse(File.open(filename).read)
      list.map do |str|
        Regexp.new(str, Regexp::IGNORECASE)
      end
    end
  end
end

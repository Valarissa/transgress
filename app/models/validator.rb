class Validator
  class << self
    def validate(document)
      regexes.each do |validator|
        return true if document.root.content =~ validator
      end

      false
    end

    def regexes
      @list ||= parse_json_list
    end

    def parse_json_list
      filename = Rails.root + 'lib/assets/javascripts/string_list.json'
      list = JSON.parse(File.open(filename).read)
      list.map do |str|
        Regexp.new(str, Regexp::IGNORECASE)
      end
    end
  end
end

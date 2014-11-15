class Validator
  class << self
    def validate(document)
      content = document.root.content
      content.encode!('UTF-8', 'UTF-8', :invalid => :replace)

      safe_regexes.each do |validator|
        return true if content =~ validator
      end

      check_flagged_terms(content)
    end

    def check_flagged_terms(content)
      potential = false
      flagged_regexes.each do |validator|
        if content =~ validator
          potential = true
          break
        end
      end

      if potential
        redemption_regexes.each do |validator|
          return true if content =~ validator
        end
      end

      false
    end

    def regexes
      @list ||= safe_regexes + flagged_regexes
    end

    def safe_regexes
      parse_json_list['safe']
    end

    def flagged_regexes
      parse_json_list['flagged']
    end

    def redemption_regexes
      parse_json_list['redemption']
    end

    private

    def parse_json_list
      return @parsed_file if defined? @parsed_file
      filename = Rails.root + 'public/assets/string_list.json'
      list = JSON.parse(File.open(filename).read)
      @parsed_file = list.each do |category, arr|
        arr.map! do |str|
          Regexp.new(str, Regexp::IGNORECASE)
        end
      end
    end
  end
end

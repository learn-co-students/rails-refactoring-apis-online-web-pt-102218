class GithubRepo

    attr_accessor :name, :url
    
    def initialize(attributes)
        @name = attributes["name"]
        @url = attributes["html_url"]
    end
end
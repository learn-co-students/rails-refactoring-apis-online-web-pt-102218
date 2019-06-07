class GithubRepo

  attr_reader :name, :url

  def initialize(hash)
    @nam = hash["name"]
    @url = hash["html_url"]
  end

end
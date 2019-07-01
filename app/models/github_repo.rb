class GithubRepo
  attr_reader :name, :url

  def initialize(init_hash = nil)
    if init_hash
      @name = init_hash['name']
      @url = init_hash['html_url']   
    end
  end

end

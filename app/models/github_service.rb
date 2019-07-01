class GithubService
  attr_reader :access_token

  def initialize(access_hash = nil)
    # byebug
    @access_token = !!access_hash ? access_hash['access_token'] : nil
  end

  def authenticate!(client_id, client_secret, code)
    response = Faraday.post "https://github.com/login/oauth/access_token" do |req|
      req.body = {
        'client_id': client_id, 
        'client_secret': client_secret,
        'code': code 
      }
      req.headers = {
        'Accept' => 'application/json'
      }
    end
    access_hash = JSON.parse(response.body)
    @access_token = access_hash["access_token"]
  end

  def get_username
    response = authorized_get("https://api.github.com/user")
    return response["login"]
  end

  def get_repos()
    repos = authorized_get("https://api.github.com/user/repos")
    return repos.map do |r|
      GithubRepo.new(r)
    end

  end

  def create_repo(name)
    response = Faraday.post "https://api.github.com/user/repos" do |req|
      req.headers['Authorization'] = "token #{self.access_token}"
      req.body =  {"name":name}.to_json 
    end

  end

  def authorized_get(url)
    response = Faraday.get "#{url}" do |req|
      req.headers['Authorization'] = "token #{self.access_token}"
    end
    json = JSON.parse(response.body)
  end

end
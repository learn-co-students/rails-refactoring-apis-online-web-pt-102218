class GithubService

    attr_accessor :access_token

    def initialize(access_hash = {access_token: nil})
        @access_token = access_hash['access_token']
    end

    def authenticate!(github_client_id, github_secret, code)
        response = Faraday.post "https://github.com/login/oauth/access_token", {client_id: github_client_id, client_secret: github_secret,code: code}, {'Accept' => 'application/json'}
        access_hash = JSON.parse(response.body)
        @access_token = access_hash["access_token"]
    end

    def get_username
        user_response = Faraday.get "https://api.github.com/user", {}, {'Authorization' => "token #{self.access_token}", 'Accept' => 'application/json'}
        user_json = JSON.parse(user_response.body)
        @username = user_json["login"]
    end

    def get_repos
        response = Faraday.get "https://api.github.com/user/repos", {}, {'Authorization' => "token #{self.access_token}", 'Accept' => 'application/json'}
        repos = JSON.parse(response.body)
        @repos_array = repos.map do |repo|
            GithubRepo.new(repo)
        end
    end

    def create_repo(name)
        response = Faraday.post "https://api.github.com/user/repos", {name: name}.to_json, {'Authorization' => "token #{self.access_token}", 'Accept' => 'application/json'}
    end
end
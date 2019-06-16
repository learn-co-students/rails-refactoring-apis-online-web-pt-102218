class GithubService
    attr_accessor :access_token, :user_name
    def initialize(access_hash = {access_token: nil})
        @access_token = access_hash['access_token']
         
    end

    def authenticate!(client,secret,code)
        response = Faraday.post "https://github.com/login/oauth/access_token", {client_id: client, client_secret: secret,code: code}, {'Accept' => 'application/json'}
        access_hash = JSON.parse(response.body)
        
        @access_token = access_hash["access_token"]

  
    end

    def get_username
        user_response = Faraday.get "https://api.github.com/user", {}, {'Authorization' => "token #{@access_token}", 'Accept' => 'application/json'}
        user_json = JSON.parse(user_response.body)
        @user_name = user_json["login"]
    end

    def get_repos
        response = Faraday.get "https://api.github.com/user/repos", {}, {'Authorization' => "token #{@access_token}", 'Accept' => 'application/json'}
        repos_array = JSON.parse(response.body)
        repos_array.map do |repo|
             
            GithubRepo.new(repo)
        end
    end

    def create_repo(name)
        response = Faraday.post "https://api.github.com/user/repos", {name: name}.to_json, {'Authorization' => "token #{@access_token}", 'Accept' => 'application/json'}
    end

end
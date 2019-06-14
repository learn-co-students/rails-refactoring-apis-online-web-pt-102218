
class SessionsController < ApplicationController
  skip_before_action :authenticate_user, only: :create

  def create
    response = GithubService.new
    token = response.authenticate!(ENV["GITHUB_CLIENT"], ENV["GITHUB_SECRET"], params[:code])
    session[:token] = token

    username = response.get_username
    session[:username] = username

    redirect_to '/'
  end
end
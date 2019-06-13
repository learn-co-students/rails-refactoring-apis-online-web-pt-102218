class SessionsController < ApplicationController
  skip_before_action :authenticate_user, only: :create

  def create
   github_service = GithubService.new 
   session[:token] = github_service.authenticate!(ENV['GITHUB_CLIENT_ID'], ENV['GITHUB_SECRET'], params[:code])

    redirect_to '/'
  end
end
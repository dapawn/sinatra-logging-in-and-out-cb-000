require_relative '../../config/environment'
require 'pry'

class ApplicationController < Sinatra::Base
  configure do
    set :views, Proc.new { File.join(root, "../views/") }
    enable :sessions unless test?
    set :session_secret, "secret"
  end

  get '/' do
    erb :index
  end

  post '/login' do
    @user = User.new(username: params["username"], password: params["password"], balance: 0)
    @user.save 
    session[:user_id] = @user.id

    if @user = User.find_by(username: params["username"])
      redirect '/account'
    else
      puts "Login Error"
      erb :error
    end
  end

  get '/account' do
    if @user = User.find_by(user_id: params["username"])
      @user = Helper.current_user(session)
      erb :account
    else
      puts "account Error"
      erb :error
    end
  end

  get '/logout' do
    session.clear
    redirect '/'
  end


end

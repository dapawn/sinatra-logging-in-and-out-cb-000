require_relative '../../config/environment'
require_relative '../helpers/helpers'
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
    @user = User.new(username: params["username"], password: params["password"], balance: 0.0)
    @user.save
    session[:user_id] = @user.id

    if Helper.is_logged_in?(session)
      redirect '/account'
    else
      puts "Login Error"
      erb :error
    end
  end

  get '/account' do
    puts "account Error"
    if Helper.is_logged_in?(session)
      @user = Helper.current_user(session)
      erb :account
    else
      erb :error
    end
  end

  get '/logout' do
    session.clear
    redirect '/'
  end


end

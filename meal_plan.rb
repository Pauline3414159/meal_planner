require 'sinatra'
require 'sinatra/reloader' if development?
require "sinatra/content_for"
require "tilt/erubis"
require 'psych'
require_relative "lib/week.rb"

configure do
  enable :sessions
  set :session_secret, 'secret'
  set :erb, :escape_html => true  
end

DAYS = %w(Sunday Monday Tuesday Wednesday Thursday Friday Saturday)
  
  


helpers do
  def load_week
    session[:week]
  end
end

get "/" do
  redirect "/index"
end

get "/index" do
  @week = load_week
  erb :index
end

get "/:day" do
  @week = load_week
  i_finder = @week.index { |d| d.day_of_week == params[:day]}
  @current_day = @week[i_finder]
  erb :day
end

post "/:day/add_meal" do
  @week = load_week
  i_finder = @week.index { |d| d.day_of_week == params[:day]}
  session[:week][i_finder].add(params[:type])
  redirect "/#{params[:day]}"
end

post "/:day/meal" do
  
end


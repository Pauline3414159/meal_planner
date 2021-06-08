require 'sinatra'
require 'sinatra/reloader' if development?
require "sinatra/content_for"
require "tilt/erubis"
require_relative "lib/week.rb"

configure do
  enable :sessions
  set :session_secret, 'secret'
  set :erb, :escape_html => true
end

before do
  
  session[:week] = []
  %w(Sunday Monday Tuesday Wednesday Thursday Friday Saturday).each do |day|
    session[:week] << Day.new(day)
  end
end

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

post "/:day" do
  
end

post "/:day/meal" do
  
end


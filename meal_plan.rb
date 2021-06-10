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

before do
  @week = Psych.load_file("data/working_week.yaml").map do |d|
    current = Day.new(d[:day_of_week])
    current.meals = d[:meals].map { |m| meal_builder(m)}
    current
  end
end

helpers do
  def meal_parser(meal)
    {type: meal.type, courses: meal.courses}
  end

  def meal_builder(hsh)
    temp = Meal.new(hsh[:type])
    temp.courses = hsh[:courses]
    temp
  end
end

get "/" do
  redirect "/index"
end

get "/index" do
  
  erb :index
end

get "/:day" do
  i_finder = @week.index { |d| d.day_of_week == params[:day]}
  @current_day = @week[i_finder]
  erb :day
end

post "/:day/add_meal" do
  i_finder = @week.index { |d| d.day_of_week == params[:day]}
  @week[i_finder].add(params[:type])
  temp = @week.map do |d|
    {day_of_week: d.day_of_week, meals: d.meals.map{|m| meal_parser(m)}}
  end
  File.open("data/working_week.yaml", "w") do |f|
    f.write(temp.to_yaml)
  end
  redirect "/#{params[:day]}"
end

post "/:day/meal" do
  
end


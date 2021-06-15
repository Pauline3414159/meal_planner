require 'sinatra'
require 'sinatra/reloader' if development?
require "sinatra/content_for"
require "tilt/erubis"
require 'psych'
require_relative "lib/day.rb"

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

  def save_week
    @week.map do |d|
      {day_of_week: d.day_of_week, meals: d.meals.map{|m| meal_parser(m)}}
    end
  end
end

# Create

post "/:day/add_meal" do
  i_finder = @week.index { |d| d.day_of_week == params[:day]}
  begin
    @week[i_finder].add(params[:type])
  rescue => exception
    session[:error] = exception.to_s
    redirect back
  else
    File.open("data/working_week.yaml", "w") do |f|
      f.write(save_week.to_yaml)
    end
    session[:success] = "#{params[:type]} was added to the meal plan"
    redirect "/#{params[:day]}"
  end  
end

post "/:day/:meal/add_course" do
  i_finder = @week.index { |d| d.day_of_week == params[:day]}
  @current_day = @week[i_finder]
  meal_i_finder = @current_day.meals.index{ |m| m.type == params[:meal]}
  @current_meal = @current_day.meals[meal_i_finder]
  begin
    @current_meal.add(params[:add_course])
  rescue => exception
    session[:error] = exception.to_s
    redirect back
  else
    File.open("data/working_week.yaml", "w") do |f|
      f.write(save_week.to_yaml)
    end
    session[:success] = "#{params[:add_course]} was added to #{params[:day]} #{params[:meal]}"
    redirect "/#{@current_day.day_of_week}/#{@current_meal.type}"
  end
end

# Read

get "/" do
  redirect "/index"
end

get "/index" do
  
  erb :index
end

get "/:day" do
  i_finder = @week.index { |d| d.day_of_week == params[:day]}
  @current_day = @week[i_finder]
  if @current_day.meals.empty?
    erb :empty_day
  elsif @current_day.meals.size.between?(1,2)
    erb :partial_day
  elsif @current_day.meals.size >= 3
    erb :full_day
  end
end

get "/:day/:meal" do
  i_finder = @week.index { |d| d.day_of_week == params[:day]}
  @current_day = @week[i_finder]
  meal_i_finder = @current_day.meals.index{ |m| m.type == params[:meal]}
  @current_meal = @current_day.meals[meal_i_finder]
  if @current_meal.courses.empty?
    erb :empty_meal
  elsif @current_meal.courses.size.between?(1,2)
    erb :partial_meal
  elsif @current_meal.courses.size >= 3
    erb :full_meal
  end
end

# Update

post "/:day/re_name_meal" do
  i_finder = @week.index { |d| d.day_of_week == params[:day]}
  begin
    @week[i_finder].reclassify(params[:be_type], params[:re_type])
  rescue => exception
    session[:error] = exception.to_s
    redirect back
  else
    File.open("data/working_week.yaml", "w") do |f|
      f.write(save_week.to_yaml)
    end
    session[:success] = "#{params[:be_type]} was changed to #{params[:re_type]}"
    redirect "/#{params[:day]}"
  end
  
end

post "/:day/:meal/rename_course" do
  i_finder = @week.index { |d| d.day_of_week == params[:day]}
  @current_day = @week[i_finder]
  meal_i_finder = @current_day.meals.index{ |m| m.type == params[:meal]}
  @current_meal = @current_day.meals[meal_i_finder]
  begin
    @current_meal.rename(params[:current_course], params[:new_name])
  rescue => exception
    session[:error] = exception.to_s
    redirect back
  else
    File.open("data/working_week.yaml", "w") do |f|
      f.write(save_week.to_yaml)
    end
    session[:success] = "#{params[:current_course]} was changed to #{params[:new_name]}"
    redirect "/#{@current_day.day_of_week}/#{@current_meal.type}"
  end
end

# Delete

post "/:day/delete_meal" do
  i_finder = @week.index { |d| d.day_of_week == params[:day]}
  begin
    @week[i_finder].remove(params[:del_type])
  rescue => exception
    session[:error] = exception.to_s
    redirect back
  else
    File.open("data/working_week.yaml", "w") do |f|
      f.write(save_week.to_yaml)
    end
    session[:success] = "#{params[:del_type]} was removed from the meal plan"
    redirect "/#{params[:day]}"
  end
end

post "/clear_all" do
  temp = @week.map do |d|
    {day_of_week: d.day_of_week, meals: []}
  end
  File.open("data/working_week.yaml", "w") do |f|
    f.write(temp.to_yaml)
  end
  session[:success] = "Everyting was deleted. Here's to a fresh start! :)"
  redirect "/"
end

post "/:day/:meal/delete_course" do
  i_finder = @week.index { |d| d.day_of_week == params[:day]}
  @current_day = @week[i_finder]
  meal_i_finder = @current_day.meals.index{ |m| m.type == params[:meal]}
  @current_meal = @current_day.meals[meal_i_finder]
  begin
    @current_meal.remove(params[:delete_course])
  rescue => exception
    session[:error] = exception.to_s
    redirect back
  else
    File.open("data/working_week.yaml", "w") do |f|
      f.write(save_week.to_yaml)
    end
    session[:success] = "#{params[:delete_course]} was removed from #{params[:day]} #{params[:meal]}"
    redirect "/#{@current_day.day_of_week}/#{@current_meal.type}"
  end
end


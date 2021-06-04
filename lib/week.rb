require_relative "meal"

class Day
  def initialize(day_of_week)
    @day_of_week = day_of_week
    @meals = [] 
  end

  def add(meal_type)
    raise StandardError.new "You can only have three meals in a day" if meals.size == 3
    raise ArgumentError.new "You can only have each type of meal once a day" if meals.map { |m| m.type}.include?(meal_type)
    meals << Meal.new(meal_type)
  end

  def remove(meal_num)
    raise ArgumentError.new "there's nothing to remove" if meals.empty?
    unless (1..meals.size).include?(meal_num) then raise ArgumentError.new "Enter a number between 1 and #{meals.size}" end
    meals.delete_at(meal_num-1)
  end

  def retype(meal_num, new_type)
    unless (1...size).include?(meal_num) then raise ArgumentError.new "You can only retype a meal that exists" end
    raise ArgumentError.new "You can only have each type of meal once a day" if meals.map { |m| m.type}.include?(meal_type)
    courses[meal_num] = new_type
  end

  def to_s
    str = "#{@day_of_week} meals include:\n"
    meals.each do |meal|
      str << meal.to_s
    end
    str
  end

  

  attr_accessor :meals
end
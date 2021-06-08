# frozen_string_literal: true

require_relative 'meal'

# each day can hold up to three meals
# you can add, remove, or reclassify a meal
class Day
  def initialize(day_of_week)
    @day_of_week = day_of_week
    @meals = []
  end

  def add(meal_type)
    raise StandardError, 'You can only have three meals in a day' if meals.size == 3
    raise ArgumentError, 'You can only have each type of meal once a day' if meals.map(&:type).include?(meal_type)

    meals << Meal.new(meal_type)
  end

  def remove(meal)
    raise ArgumentError, "there's nothing to remove" if meals.empty?
    raise ArgumentError, "no meals of the #{meal} type to remove" unless meals.map(&:type).include?(meal)

    i_finder = meals.index { |m| m.type == meal }
    meals.delete_at(i_finder)
  end

  def reclassify(meal, new_type)
    raise ArgumentError, "there's nothing to reclassify" if meals.empty?
    raise ArgumentError, 'You can only have each type of meal once a day' if meals.map(&:type).include?(new_type)

    i_finder = meals.index { |m| m.type == meal }
    raise ArgumentError, "No such #{meal} to reclassify" if i_finder.nil?

    meals[i_finder].type = new_type
  end

  def to_s
    str = "#{@day_of_week} meals include:\n"
    meals.each do |meal|
      str << "\s\s#{meal}\n"
    end
    str
  end

  attr_accessor :meals
end

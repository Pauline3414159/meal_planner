# A meal has up to three courses (a string descriptor)
# you can add, remove, or rename courses
# a meal has an attribute of type and courses (an array)
class Meal
  TYPES = %w[breakfast brunch lunch tea dinner snack].freeze

  def initialize(type)
    @type = type
    @courses = []
  end

  attr_accessor :type
  def add(course)
    raise StandardError, 'You can only have three courses in a meal' if courses.size == 3

    courses << course
  end

  def remove(course)
    raise ArgumentError, 'no courses to delete' if courses.empty?
    raise ArgumentError, 'Enter a valid course' unless courses.include?(course)

    i_finder = courses.index(course)
    courses.delete_at(i_finder)
  end

  def rename(course, new_dish)
    raise ArgumentError, 'Enter a valid course' unless courses.include?(course)

    i_finder = courses.index(course)
    courses[i_finder] = new_dish
  end

  def to_s
    str = "#{type} includes:\n"
    courses.each_with_index do |course, i|
      str << " Course # #{i + 1} : #{course} \n"
    end
    str.chomp
  end

  

  attr_accessor :courses
end

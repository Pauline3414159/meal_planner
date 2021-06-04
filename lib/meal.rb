

class Meal
  def initialize(type)
    @type = type
    @courses = []
  end

  attr_accessor :type

  def add(course)
    raise StandardError.new "You can only have three courses in a meal" if courses.size == 3
    courses << course
  end

  def remove(course_num)
    unless (1..3).include?(course_num) then raise ArgumentError.new "Enter a number between 1 and 3" end
    courses.delete_at(course_num-1)
  end

  def rename(course_num, new_dish)
    unless (1..courses.size).include?(course_num) then raise ArgumentError.new "You can only rename a course that exists" end
    courses[course_num] = new_dish
  end

  def to_s
    str = "#{type} includes:\n"
    courses.each_with_index do |course, i|
      str << " Course # #{i+1} : #{course} \n"
    end
    str.chomp
  end

  private
  attr_accessor :courses
end

pauline = Meal.new("breakfast")

pauline.add("oatmeal porrige")
pauline.add("jj")
pauline.add('oo')

p pauline.remove(3)

pauline.rename(1, "yes")

puts pauline

p pauline.class

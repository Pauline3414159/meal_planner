require "minitest/autorun"
require_relative "week"

class WeekTest < Minitest::Test
  def test_add_a_meal
    day = Day.new("Sunday")
    day.add("breakfast")
    assert_includes day.meals.map { |m| m.type}, "breakfast"
  end

  def test_more_than_three_meals_makes_error
    day = Day.new("Sunday")
    day.add("breakfast")
    day.add("lunch")
    day.add("dinner")
    assert_raises StandardError do
      day.add("second breakfast")
    end
  end

  def test_same_type_of_meal_twice_in_a_day_error
    day = Day.new("Sunday")
    day.add("breakfast")
    assert_raises ArgumentError do
      day.add("breakfast")
    end
  end

  def test_remove_a_meal
    day = Day.new("Sunday")
    day.add("breakfast")
    day.add("lunch")
    assert_equal "breakfast", day.remove(1).type
  end

  def test_remove_non_existant_meal
    day = Day.new("Sunday")
    day.add("breakfast")
    day.add("lunch")
    second = Day.new("Monday")
    assert_raises ArgumentError do
      day.remove(5)
    end
    assert_raises ArgumentError do
      second.remove(1)
    end

  end

  def test_retype_meal

  end

  def test_non_existant_retype_meal

  end

  def test_repeat_retype_meal

  end

  def test_add_course

  end

  def test_add_too_many_course

  end

  def test_rename_course

  end

  def test_rename_non_existant_course
    
  end

  def test
    
  end
end
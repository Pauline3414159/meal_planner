require "minitest/autorun"
require_relative "day"

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
    assert_equal "breakfast", day.remove("breakfast").type
  end

  def test_remove_non_existant_meal
    day = Day.new("Sunday")
    day.add("breakfast")
    day.add("lunch")
    second = Day.new("Monday")
    assert_raises ArgumentError do
      day.remove("wha")
    end
    assert_raises ArgumentError do
      second.remove("breakfast")
    end

  end

  def test_reclassify_meal
    day = Day.new("Sunday")
    day.add("breakfast")
    day.reclassify("breakfast", "lunch")
    assert_equal "lunch", day.remove("lunch").type
  end

  def test_reclassify_non_existant_meal
    day = Day.new("Sunday")
    day.add("breakfast")
    assert_raises ArgumentError do
      day.reclassify("dinner", "lunch")
    end
  end

  def test_repeat_reclassify_meal
    day = Day.new("Sunday")
    day.add("breakfast")
    day.add("dinner")
    assert_raises ArgumentError do
      day.reclassify("breakfast", "dinner")
    end
  end

  def test_add_course
    a_meal = Meal.new("breakfast")
    a_meal.add("eggs")
    a_meal.add("bacon")
    assert_equal true, a_meal.to_s.include?("eggs")
  end

  def test_add_too_many_course
    a_meal = Meal.new("breakfast")
    a_meal.add("eggs")
    a_meal.add("bacon")
    a_meal.add("potato")
    assert_raises StandardError do
      a_meal.add("muffin")
    end
  end

  def test_rename_course
    a_meal = Meal.new("breakfast")
    a_meal.add("eggs")
    a_meal.add("bacon")
    a_meal.rename("eggs", "tofu")
    assert_equal true, a_meal.to_s.include?("tofu")
  end

  def test_rename_non_existant_course
    a_meal = Meal.new("breakfast")
    assert_raises ArgumentError do
      a_meal.rename("eggs", "tofu")
    end
  end

  def test_delete_course
    a_meal = Meal.new("breakfast")
    a_meal.add("eggs")
    a_meal.add("bacon")
    a_meal.remove("eggs")
    refute a_meal.to_s.include?("eggs")
    meal_two = Meal.new("lunch")
    assert_raises ArgumentError do
      meal_two.remove("food")
    end
  end
end
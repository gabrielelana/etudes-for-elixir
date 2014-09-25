# Write a list comprehension that creates a list consisting of the names of all
# the people who are male and over 40. Use pattern matching to separate the
# tuple into three variables, and use two guards to do the tests for age and
# gender. When you use multiple guards in a list comprehension, you get the
# moral equivalent of combining the conditions with and.

# Then, write a list comprehension that selects the names of all the people who
# are male or over 40. You can’t use multiple guards here; you want a single
# guard that explicitly uses the or operator.

ExUnit.start

defmodule PatternMatchingInsideListComprehension do
  use ExUnit.Case

  @people [
    {"Federico", "M", 22}, {"Kim", "F", 45},
    {"Hansa", "F", 30}, {"Tran", "M", 47},
    {"Cathy", "F", 32}, {"Elias", "M", 50}
  ]

  test "select all males over 40" do
    assert (
      (for person = {_, gender, age} <- @people, gender == "M", age > 40, do: person) ==
      [{"Tran", "M", 47}, {"Elias", "M", 50}]
    )
  end

  test "select all names of people that are male or over 40" do
    assert (
      (for {name, gender, age} <- @people, gender == "M" or age > 40, do: name) ==
      ["Federico", "Kim", "Tran", "Elias"]
    )
  end
end

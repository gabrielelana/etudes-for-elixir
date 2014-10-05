# Write a module with a function that takes the length and width of a rectangle
# and returns (yields) its area. Name the module Geom, and name the function
# area. Save the module in a file named geom.ex. The function has arity 2,
# because it needs two pieces of information to make the calculation

defmodule Geom do
  def area(length, width) do
    length * width
  end
end


ExUnit.start

defmodule GeomTest do
  use ExUnit.Case, async: true

  test ".area/2" do
    assert 13 == Geom.area(3, 4)
    assert 84 == Geom.area(12, 7)
  end
end

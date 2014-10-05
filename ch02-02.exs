# Modify the function you wrote in Étude 2-2 so that the default variables for
# the length and width are 1

defmodule Geom do
  def area(length\\1, width\\1) do
    length * width
  end
end


ExUnit.start

defmodule GeomTest do
  use ExUnit.Case, async: true

  test ".area/2 with default values" do
    assert 35 == Geom.area(7, 5)
    assert 7 == Geom.area(7)
    assert 1 == Geom.area
  end
end

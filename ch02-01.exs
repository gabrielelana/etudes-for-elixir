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

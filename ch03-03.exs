defmodule Geom do
  @vsn 0.1
  @moduledoc """
  Functions to calculate areas of various shapes.
  """

  @doc """
  Calculates the area of a shape, given the shape and its dimensions.
  Accepts only dimensions that are not negative.
  """

  @spec area(atom(), number(), number()) :: number()

  def area(shape, d1, d2) when d1 >= 0 and d2 >= 0 do
    _area(shape, d1, d2)
  end

  def area(_, _, _) do
    0
  end

  defp _area(:rectangle, width, length) do
    width * length
  end

  defp _area(:triangle, base, height) do
    base * height / 2.0
  end

  defp _area(:ellipse, semi_major, semi_minor) do
    :math.pi * semi_major * semi_minor
  end

  defp _area(_, _, _) do
    0
  end
end


ExUnit.start

defmodule GeomTest do
  use ExUnit.Case, async: true

  test ".area/3 with not supported shape" do
    assert 0 == Geom.area(:pentagon, 3, 4)
  end

  test ".area/3 with negative numbers" do
    assert 0 == Geom.area(:triangle, -3, 4)
    assert 0 == Geom.area(:ellipse, -3, -4)
  end
end

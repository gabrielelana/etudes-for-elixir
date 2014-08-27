defmodule Geom do
  @vsn 0.1
  @moduledoc """
  Functions to calculate areas of various shapes.
  """

  @doc """
  Calculates the area of a shape, given the shape and its dimensions
  """

  @spec area(atom(), number(), number()) :: number()

  def area(:rectangle, width, length) do
    width * length
  end

  def area(:triangle, base, height) do
    base * height / 2.0
  end

  def area(:ellipse, semi_major, semi_minor) do
    :math.pi * semi_major * semi_minor
  end
end


ExUnit.start

defmodule GeomTest do
  use ExUnit.Case, async: true

  test ".area/3 for :rectangle" do
    assert 12 == Geom.area(:rectangle, 3, 4)
  end

  test ".area/3 for :triangle" do
    assert 7.5 == Geom.area(:triangle, 3, 5)
  end

  test ".area/3 for :ellipse" do
    assert 25.132741228718345 == Geom.area(:ellipse, 2, 4)

    # or a more appropriate assertion
    assert_in_delta 25.13, Geom.area(:ellipse, 2, 4), 0.01
  end
end

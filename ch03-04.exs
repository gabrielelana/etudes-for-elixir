defmodule Geom do
  @vsn 0.1
  @moduledoc """
  Functions to calculate areas of various shapes.
  """

  @doc """
  Calculates the area of a shape, given the shape and its dimensions.
  """

  @spec area({atom(), number(), number()}) :: number()

  def area({shape, d1, d2}) do
    _area(shape, d1, d2)
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
end


ExUnit.start

defmodule GeomTest do
  use ExUnit.Case, async: true

  test ".area/1" do
    assert 21 == Geom.area({:rectangle, 7, 3})
    assert 10.5 == Geom.area({:triangle, 7, 3})
    assert_in_delta 65.97, Geom.area({:ellipse, 7, 3}), 0.01
  end

  test ".area/1 with usupported shapes" do
    catch_error Geom.area({:pentagon, 7, 3})
    catch_error Geom.area(:rectangle, 7, 3)
  end
end

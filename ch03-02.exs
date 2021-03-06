# Even though you won’t get an error message when calculating the area of a
# shape that has negative dimensions, it’s still worth guarding your area/3
# function. You will want two guards for each pattern to make sure that both
# dimensions are greater than or equal to zero. Since both have to be
# non-negative, use and to separate your guards.

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

  test ".area/3 for :rectangle with negative number" do
    catch_error Geom.area(:rectangle, -3, 4)
  end

  test ".area/3 for :triangle with negative number" do
    catch_error Geom.area(:triangle, 3, -4)
  end

  test ".area/3 for :ellipse with negative number" do
    catch_error Geom.area(:ellipse, -3, -4)
  end
end

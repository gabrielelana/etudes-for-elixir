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
    case shape do
      :rectangle -> d1 * d2
      :triangle -> d1 * d2 / 2.0
      :ellipse -> :math.pi * d1 * d2
    end
  end
end

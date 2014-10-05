# Document the Geom module and area function that you wrote in Étude 2-2

defmodule Geom do
  @vsn 0.1
  @moduledoc """
  Functions to calculate areas of various shapes.
  """

  @doc """
  Calculates the area of a shape, given the shape and its dimensions
  """

  @spec area(number(), number()) :: number()

  def area(length\\1, width\\1) do
    length * width
  end
end

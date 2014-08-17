defmodule Geom do
  @vsn 0.1
  @moduledoc """
  Functions to calculate areas of various shapes.
  """

  @spec area(number(), number()) :: number()
  @doc """
  Calculates the area of a rectangle given length and width
  """
  def area(length\\1, width\\1) do
    length * width
  end
end

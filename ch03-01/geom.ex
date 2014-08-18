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

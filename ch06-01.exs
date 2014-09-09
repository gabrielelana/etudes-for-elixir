# In a module named Stats, write these functions:
#
# * minimum/1, which takes a list of numbers as its argument and returns the
#   smallest value.
# * maximum/1, which takes a list of numbers as its argument and
#   returns the largest value.
# * range/1, which takes a list of numbers as its
#   argument and returns a list containing the maximum and minimum values in the
#   list.

defmodule Stats do

  @moduledoc """
  Provides some statistical functions

  ## Examples

    iex(2)> data = [4, 1, 7, -17, 8, 2, 5]
    [4,1,7,-17,8,2,5]
    iex(3)> Stats.minimum(data)
    -17
    iex(4)> Stats.minimum([52, 46])
    46
    iex(5)> Stats.maximum(data)
    8
    iex(6)> Stats.range(data)
    [-17,8]

  """

  def minimum(l) do
    minimum(l, :"infinity+")
  end

  defp minimum([h|t], :"infinity+"), do: minimum(t, h)
  defp minimum([], so_far), do: so_far
  defp minimum([h|t], so_far) when h < so_far, do: minimum(t, h)
  defp minimum([_|t], so_far), do: minimum(t, so_far)


  def maximum(l) do
    maximum(l, :"infinity-")
  end

  defp maximum([h|t], :"infinity-"), do: maximum(t, h)
  defp maximum([], so_far), do: so_far
  defp maximum([h|t], so_far) when h > so_far, do: maximum(t, h)
  defp maximum([_|t], so_far), do: maximum(t, so_far)

  def range(l) do
    [minimum(l), maximum(l)]
  end
end


ExUnit.start

defmodule StatsTest do
  use ExUnit.Case, async: true

  test "minimum/1" do
    assert Stats.minimum([4, 1, 7, -17, 8, 2, 5]) == -17
    assert Stats.minimum([]) == :"infinity+"
  end

  test "maximum/1" do
    assert Stats.maximum([4, 1, 7, -17, 8, 2, 5]) == 8
    assert Stats.maximum([]) == :"infinity-"
  end

  test "range/1" do
    assert Stats.range([4, 1, 7, -17, 8, 2, 5]) == [-17, 8]
  end
end

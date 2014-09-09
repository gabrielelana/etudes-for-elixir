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

  def minimum([h|t]) do
    scan(t, h, &scan/4, &</2)
  end

  def maximum([h|t]) do
    scan(t, h, &scan/4, &>/2)
  end

  def range(l) do
    [minimum(l), maximum(l)]
  end

  defp scan([], so_far, _, _), do: so_far
  defp scan([h|t], so_far, f, c) do
    f.(t, if(c.(h, so_far), do: h, else: so_far), f, c)
  end
end


ExUnit.start

defmodule StatsTest do
  use ExUnit.Case, async: true

  test "minimum/1" do
    assert Stats.minimum([4, 1, 7, -17, 8, 2, 5]) == -17
    catch_error Stats.minimum([])
  end

  test "maximum/1" do
    assert Stats.maximum([4, 1, 7, -17, 8, 2, 5]) == 8
    catch_error Stats.maximum([])
  end

  test "range/1" do
    assert Stats.range([4, 1, 7, -17, 8, 2, 5]) == [-17, 8]
  end
end

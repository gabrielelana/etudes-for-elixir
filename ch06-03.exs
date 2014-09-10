# Dentists check the health of your gums by checking the depth of the "pockets"
# at six different locations around each of your 32 teeth. The depth is measured
# in millimeters. If any of the depths is greater than or equal to four
# millimeters, that tooth needs attention. (Thanks to Dr. Patricia Lee, DDS, for
# explaining this to me.)
#
# Your task is to write a module named Teeth and a function named alert/1. The
# function takes a list of 32 lists of six numbers as its input. If a tooth isn’t
# present, it is represented by the list [0] instead of a list of six numbers.
# The function produces a list of the tooth numbers that require attention. The
# numbers must be in ascending order.

defmodule Teeth do

  @doc """
  Given a list of list representing tooth pocket depths, return
  a list of the tooth numbers that require attention (any pocket
  depth greater than or equal to four).
  """
  @spec alert([[]]) :: []

  def alert(pocket_depths) do
    Enum.with_index(pocket_depths) |>
      Enum.filter(fn({depths, _}) -> Enum.any?(depths, &(&1 >= 4)) end) |>
      Enum.map(fn({_, index}) -> index + 1 end)
  end
end

ExUnit.start

defmodule TeethTest do
  use ExUnit.Case, async: true

  test "alert/1" do
    pocket_depths = [
      [0], [2,2,1,2,2,1], [3,1,2,3,2,3], [3,1,3,2,1,2], [3,2,3,2,2,1],
      [2,3,1,2,1,1], [3,1,3,2,3,2], [3,3,2,1,3,1], [4,3,3,2,3,3],
      [3,1,1,3,2,2], [4,3,4,3,2,3], [2,3,1,3,2,2], [1,2,1,1,3,2],
      [1,2,2,3,2,3], [1,3,2,1,3,3], [0], [3,2,3,1,1,2], [2,2,1,1,3,2],
      [2,1,1,1,1,2], [3,3,2,1,1,3], [3,1,3,2,3,2], [3,3,1,2,3,3],
      [1,2,2,3,3,3], [2,2,3,2,3,3], [2,2,2,4,3,4], [3,4,3,3,3,4],
      [1,1,2,3,1,2], [2,2,3,2,1,3], [3,4,2,4,4,3], [3,3,2,1,2,3],
      [2,2,2,2,3,3], [3,2,3,2,3,2]]

    assert Teeth.alert(pocket_depths) == [9,11,25,26,29]
  end
end

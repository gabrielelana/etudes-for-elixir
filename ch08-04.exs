# Use Enum.split/2 and List.foldl/3 to rewrite the Dates.julian/1 function from
# Étude 6-2. Hint: you will use those functions when calculating the total
# number of days up to (but not including) the month in question.

defmodule Dates do

  @doc "Calculate julian date from an ISO date string"
  @spec julian(String.t) :: number

  def julian(date) do
    [y, m, d] = split(date)
    days_before_month(m) + d + (if leap_year?(y) and m > 2, do: 1, else: 0)
  end

  defp days_before_month(m) do
    {before, _after} = Enum.split([31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31], m - 1)
    Enum.reduce(before, 0, &(&1 + &2))

    # Alternative

    # [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    #   |> Enum.split(m - 1)
    #   |> (fn({before, _after}) -> before end).()
    #   |> Enum.reduce(0, &(&1 + &2))
  end

  defp leap_year?(year) do
    (rem(year,4) == 0 and rem(year,100) != 0) or (rem(year, 400) == 0)
  end


  @spec split(String.t) :: [String.t]

  def split(date) do
    String.split(date, "-") |> Enum.map &(String.to_integer(&1))
  end
end

ExUnit.start

defmodule DatesTest do
  use ExUnit.Case, async: true

  test "julian/1" do
    assert Dates.julian("2013-12-31") == 365
    assert Dates.julian("2012-12-31") == 366
    assert Dates.julian("2012-02-05") == 36
    assert Dates.julian("2013-02-05") == 36
    assert Dates.julian("1900-03-01") == 60
    assert Dates.julian("2000-03-01") == 61
    assert Dates.julian("2013-01-01") == 1
  end
end

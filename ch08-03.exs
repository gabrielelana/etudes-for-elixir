defmodule Stats do

  @doc "Calculates the mean of all numbers"

  @spec mean([number]) :: number

  def mean([]), do: 0.0
  def mean(numbers) do
    Enum.reduce(numbers, 0, &(&1 + &2)) / Enum.count(numbers)
  end


  @doc "Calculates the standard deviation of all numbers"

  @spec stdv([number]) :: number

  def stdv([]), do: 0.0
  def stdv(numbers) do
    [sum, sos, non] = Enum.reduce(numbers, [0,0,0], fn(number, [sum, sos, non]) ->
      [sum + number, sos + (number * number), non + 1]
    end)
    :math.sqrt(((sos * non) - (sum * sum)) / (non * (non - 1)))
  end
end


ExUnit.start


defmodule StatsTest do
  use ExUnit.Case

  test "mean/1" do
    assert Stats.mean([7, 2, 9]) == 6.0
    assert Stats.mean([1, 1, 1]) == 1
    assert Stats.mean([]) == 0
  end

  test "stdv/1" do
    assert Stats.stdv([7, 2, 9]) == 3.60555127546398912486
    assert Stats.stdv([1, 1, 1]) == 0
    assert Stats.stdv([]) == 0
  end
end

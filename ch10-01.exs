# Update the stats module that you wrote in Étude 7-3 so that it will catch
# errors in the minimum/1, maximum/1, mean/1 and stdv/1 functions.

defmodule Stats do

  @moduledoc """
  Provides some statistical functions
  """


  @doc "Calculates the mean of all numbers"
  @spec mean([number]) :: number

  def mean(numbers) do
    try do
      Enum.reduce(numbers, 0, &(&1 + &2)) / Enum.count(numbers)
    rescue
      err -> err
    end
  end


  @doc "Calculates the standard deviation of all numbers"
  @spec stdv([number]) :: number

  def stdv(numbers) do
    try do
      [sum, sos, non] = Enum.reduce(numbers, [0,0,0], fn(number, [sum, sos, non]) ->
        [sum + number, sos + (number * number), non + 1]
      end)
      :math.sqrt(((sos * non) - (sum * sum)) / (non * (non - 1)))
    rescue
      err -> err
    end
  end
end


ExUnit.start

defmodule StatsTest do
  use ExUnit.Case

  test "catch errors in mean/1" do
    assert Stats.mean([]) == %ArithmeticError{}
    assert Stats.mean([:foo, :bar]) == %ArithmeticError{}
  end

  test "catch errors in stdv/1" do
    assert Stats.stdv([]) == %ArithmeticError{}
    assert Stats.stdv([:foo, :bar]) == %ArithmeticError{}
  end
end

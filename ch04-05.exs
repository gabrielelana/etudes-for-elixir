defmodule Powers do

  @doc """
  Uses the Newton-Raphson method for calculating roots
  """

  @spec nth_root(number(), integer()) :: number()

  def nth_root(x, n) when is_integer(n) do
    nth_root(x, n, x / 2.0)
  end

  @spec nth_root(number(), integer(), number()) :: number()

  defp nth_root(x, n, a) do
    f = :math.pow(a, n) - x
    f_prime = n * :math.pow(a, n - 1)
    next_a = a - (f / f_prime)
    change = :erlang.abs(a - next_a)
    if change <= 1.0e-8 do
      next_a
    else
      nth_root(x, n, next_a)
    end
  end
end


ExUnit.start

defmodule PowersTest do
  use ExUnit.Case, async: true

  test ".nth_root/2" do
    assert 3.0 == Powers.nth_root(27, 3)
  end
end

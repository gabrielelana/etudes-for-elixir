defmodule Powers do

  @doc """
  Uses the Newton-Raphson method for calculating roots
  Solved using infinite streams of guesses, stop when the difference between
  the current guess and the next guess is less than wanted precision
  """

  @spec nth_root(number(), integer()) :: number()

  def nth_root(x, n) when is_integer(n) do
    guesses = nth_root_guesses(x, n)
    {:ok, {v, _}} =
      Stream.zip(guesses, guesses |> Stream.drop(1))
      |> Stream.map(fn({g1, g2}) -> {g2, abs(g1-g2)} end)
      |> Stream.drop_while(fn({_v, d}) -> d >= 1.0e-8 end)
      |> Enum.fetch(0)
    v
  end

  defp nth_root_guesses(x, n) do
    f = &(:math.pow(&1, n) - x)
    f_prime = &(n * :math.pow(&1, n - 1))
    guesser = &(&1 - (f.(&1) / f_prime.(&1)))
    start_at = x / 2.0
    Stream.iterate(start_at, guesser)
  end
end


ExUnit.start

defmodule PowersTest do
  use ExUnit.Case, async: true

  test ".nth_root/2" do
    assert 3.0 == Powers.nth_root(27, 3)
  end
end

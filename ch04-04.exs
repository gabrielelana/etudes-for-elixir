defmodule Powers do
  @vsn 0.1

  import Kernel, except: [raise: 2, raise: 3]

  @doc """
  Returns x^n
  """

  @spec raise(number(), number()) :: number()

  def raise(_, 0), do: 1
  def raise(x, 1), do: x

  def raise(x, n) when n > 0 do
    raise(x, n, x)
  end

  def raise(x, n) when n < 0 do
    1.0 / raise(x, -n)
  end

  @spec raise(number(), number(), number()) :: number()

  defp raise(_x, 1, accumulator), do: accumulator
  defp raise(x, n, accumulator) do
    raise(x, n - 1, x * accumulator)
  end
end


ExUnit.start

defmodule PowersTest do
  use ExUnit.Case, async: true

  test ".raise/2" do
    assert 5 == Powers.raise(5,1)
    assert 8 == Powers.raise(2,3)
    assert 1.728 == Powers.raise(1.2,3)
    assert 1 == Powers.raise(2, 0)
    assert 0.125 == Powers.raise(2, -3)
  end
end

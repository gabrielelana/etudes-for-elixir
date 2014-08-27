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

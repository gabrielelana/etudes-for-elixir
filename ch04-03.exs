defmodule Powers do
  @vsn 0.1

  import Kernel, except: [raise: 2]

  @doc """
  Returns x^n, using `cond`
  """

  @spec raise(number(), number()) :: number()

  def raise(x, n) do
    cond do
      n == 0 -> 1
      n == 1 -> x
      n > 0 -> x * raise(x, n - 1)
      n < 0 -> 1.0 / raise(x, -n)
    end
  end

  @doc """
  Returns x^n, using multiple clause with guards
  """

  @spec raise_with_guards(number(), number()) :: number()

  def raise_with_guards(_, 0), do: 1
  def raise_with_guards(x, 1), do: x

  def raise_with_guards(x, n) when n > 0 do
    x * raise_with_guards(x, n - 1)
  end

  def raise_with_guards(x, n) when n < 0 do
    1.0 / raise_with_guards(x, -n)
  end
end

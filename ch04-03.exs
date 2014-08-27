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


ExUnit.start

defmodule PowerTest do
  use ExUnit.Case, async: true

  test ".raise/2" do
    assert 5 == Powers.raise(5,1)
    assert 8 == Powers.raise(2,3)
    assert 1.728 == Powers.raise(1.2,3)
    assert 1 == Powers.raise(2, 0)
    assert 0.125 == Powers.raise(2, -3)
  end

  test ".raise_with_guards/2" do
    assert 5 == Powers.raise_with_guards(5,1)
    assert 8 == Powers.raise_with_guards(2,3)
    assert 1.728 == Powers.raise_with_guards(1.2,3)
    assert 1 == Powers.raise_with_guards(2, 0)
    assert 0.125 == Powers.raise_with_guards(2, -3)
  end
end

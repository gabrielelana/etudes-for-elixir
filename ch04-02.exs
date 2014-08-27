defmodule Dijkstra do
  @vsn 1.0

  @doc """
  Calculates the greatest common divisor of two integers.
  Uses Dijkstra's algorithm, which does not require any divisions.
  """

  @spec gcd(number(), number()) :: number()

  def gcd(m, n) do
    cond do
      m === n -> m
      m > n -> gcd(m - n, n)
      m < n -> gcd(m, n - m)
    end
  end

  @doc """
  Calculates the greatest common divisor of two integers.
  Uses Dijkstra's algorithm, which does not require any divisions.
  Uses guards instead of `cond` switch
  """

  @spec gcd_with_guards(number(), number()) :: number()

  def gcd_with_guards(m, n) when m === n do
    m
  end

  def gcd_with_guards(m, n) when m > n do
    gcd_with_guards(m - n, n)
  end

  def gcd_with_guards(m, n) when m < n do
    gcd_with_guards(m, n - m)
  end
end


ExUnit.start

defmodule DijkstraTest do
  use ExUnit.Case, async: true

  test ".gdc/2" do
    assert 2 == Dijkstra.gcd(2, 8)
    assert 7 == Dijkstra.gcd(14, 21)
    assert 1 == Dijkstra.gcd(125, 46)
    assert 12 == Dijkstra.gcd(120, 36)
  end

  test ".gcd_with_guards/2" do
    assert 2 == Dijkstra.gcd_with_guards(2, 8)
    assert 7 == Dijkstra.gcd_with_guards(14, 21)
    assert 1 == Dijkstra.gcd_with_guards(125, 46)
    assert 12 == Dijkstra.gcd_with_guards(120, 36)
  end
end

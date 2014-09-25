# In calculus, the derivative of a function is "a measure of how a function
# changes as its input changes" (Wikipedia). For example, if an object is
# traveling at a constant velocity, that velocity is the same from moment to
# moment, so the derviative is zero. If an object is falling, its velocity
# changes a little bit as the object starts falling, and then falls faster and
# faster as time goes by.

# You can calculate the rate of change of a function by calculating: (f(x +
# delta) - f(x)) / delta, where delta is the interval between measurements. As
# delta approaches zero, you get closer and closer to the true value of the
# derivative.

# Write a module named Calculus with a function derivative/2. The first
# argument is the function whose derivative you wish to find, and the second
# argument is the point at which you are measuring the derivative.

defmodule Calculus do

  @doc """
  Calculate the approximation to the derivative of function f and point x by
  using the mathematical definition of a derivative.
  """

  @spec derivative((number -> number), number) :: number

  def derivative(f, x, delta \\ 1.0e-10) do
    (f.(x + delta) - f.(x)) / delta
  end
end

ExUnit.start

defmodule CalculusTest do
  use ExUnit.Case, async: true

  test "derivative/2" do
    f1 = fn(x) -> x * x end
    assert Calculus.derivative(f1, 3) == 6.000000496442226
  end
end

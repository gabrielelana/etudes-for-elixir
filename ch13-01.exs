defmodule AtomicMaker do
  @elements [{:h, 1.008}, {:he, 4.003}]

  @elements [
    {:h, 1.008}, {:he, 4.003}, {:li, 6.94}, {:be, 9.012},
    {:b, 10.81}, {:c, 12.011}, {:n, 14.007}, {:o, 15.999},
    {:f, 18.998}, {:ne, 20.178}, {:na, 22.990}, {:mg, 24.305},
    {:al, 26.981}, {:si, 28.085}, {:p, 30.974}, {:s, 32.06},
    {:cl, 35.45}, {:ar, 39.948}, {:k, 39.098}, {:ca, 40.078},
    {:sc, 44.956}, {:ti, 47.867}, {:v, 50.942}, {:cr, 51.996},
    {:mn, 54.938}, {:fe, 55.845}
  ]

  defmacro __using__(_) do
    for {name, atomic_weight} <- @elements do
      quote do
        def unquote(name)(), do: unquote(atomic_weight)
      end
    end
  end
end


ExUnit.start

defmodule AtomicMaker.Test do
  use AtomicMaker
  use ExUnit.Case

  test "will define functions that return atomic weights" do
    assert h == 1.008
    assert he == 4.003
    assert si == 28.085
  end
end

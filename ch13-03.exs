defmodule Duration do
  defmacro {m1, s1} + {m2, s2} do
    quote do
      seconds = rem(unquote(s1) + unquote(s2), 60)
      minutes = div(unquote(s1) + unquote(s2), 60)
      {unquote(m1) + unquote(m2) + minutes, seconds}
    end
  end
  defmacro a1 + a2 do
    quote do
      unquote(a1) + unquote(a2)
    end
  end
end


ExUnit.start

defmodule Duration.Test do
  use ExUnit.Case

  require Duration

  test "add as an overloading of operator +" do
    assert Duration.+({2, 15}, {3, 12}) == {5, 27}
  end

  test "add as an overloading of operator + imported" do
    import Duration
    import Kernel, except: [+: 2]
    assert {2, 15} + {3, 12} == {5, 27}
    assert 3 + 9 == 12
  end

  test "import is local to the scope where it's used" do
    catch_error _ = {2, 15} + {3, 12}
  end
end

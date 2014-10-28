defmodule Duration do
  defmacro add({m1, s1}, {m2, s2}) do
    quote do
      seconds = rem(unquote(s1) + unquote(s2), 60)
      minutes = div(unquote(s1) + unquote(s2), 60)
      {unquote(m1) + unquote(m2) + minutes, seconds}
    end
  end
end


ExUnit.start

defmodule Duration.Test do
  use ExUnit.Case

  require Duration

  test "add" do
    assert Duration.add({2, 15}, {3, 12}) == {5, 27}
    assert Duration.add({2*3, 15-5}, {6/2, 12+3}) == {9, 25}
    assert Duration.add({10, 42}, {10, 42}) == {21, 24}
  end
end

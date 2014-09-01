defmodule Dates do

  @spec date_parts(String.t) :: [String.t]

  def date_parts(date) do
    String.split(date, "-") |> Enum.map &(String.to_integer(&1))
  end
end


ExUnit.start

defmodule DatesTest do
  use ExUnit.Case, async: true

  test ".date_parts/1" do
    assert [2013, 06, 15] == Dates.date_parts("2013-06-15")
  end
end

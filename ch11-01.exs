# In a module named PhoneETS, read a data file of phone call summaries and
# create an ETS table for the calls. The function that does this will be named
# setup/1, and its argument will be the name of the file containing the data.

defmodule Phone do
  require Record;

  Record.defrecord :phone,
    number: nil,
    start_date: "1900-01-01", start_time: "00:00:00",
    end_date: "1900-01-01", end_time: "00:00:00:00"
end

defmodule Phone.ETS do
  require Phone

  def setup(file_path) do
    :ets.new(:calls, [:named_table, :bag, {:keypos, Phone.phone(:number) + 1}])

    File.stream!(file_path, [:read, :utf8])
      |> Enum.map(&split(&1))
      |> Enum.each(&add(&1))
  end

  def lookup(number) do
    :ets.lookup(:calls, number)
  end

  defp split(line) do
    line |> String.split(~r/[,\n]/, trim: true)
  end

  defp add([number, start_date, start_time, end_date, end_time]) do
    :ets.insert(:calls, Phone.phone(number: number,
      start_date: start_date, start_time: start_time,
      end_date: end_date, end_time: end_time
    ))
  end
end


ExUnit.start

defmodule Phone.Test do
  use ExUnit.Case, async: false

  test "create ETS table made of records" do
    Phone.ETS.setup("ch11-01-calls.csv")
    assert Phone.ETS.lookup("650-555-3326") == [
      {:phone, "650-555-3326", "2013-03-10", "09:01:47", "2013-03-10", "09:05:11"},
      {:phone, "650-555-3326", "2013-03-10", "09:05:48", "2013-03-10", "09:09:08"},
      {:phone, "650-555-3326", "2013-03-10", "09:10:12", "2013-03-10", "09:13:09"}
    ]
  end
end

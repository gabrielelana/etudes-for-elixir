# In a module named PhoneETS, read a data file of phone call summaries and
# create an ETS table for the calls. The function that does this will be named
# setup/1, and its argument will be the name of the file containing the data.

# Write functions to summarize the number of minutes for a single phone number
# (summary/1) or for all phone numbers. (summary/0). These functions return a
# list of tuples in the form:

# [{phoneNumber1, minutes]},{phoneNumber2, minutes}, …]


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

  def summary do
    summary({:phone, :"_", :"_", :"_", :"_", :"_"})
  end

  def summary(number) when is_binary(number) do
    summary({:phone, number, :"_", :"_", :"_", :"_"}) |> List.first
  end

  def summary(pattern) do
    :ets.match_object(:calls, pattern)
        |> Enum.group_by(fn({:phone, number, _, _, _, _}) -> number end)
        |> Enum.map(
            fn({number, calls}) ->
              { number,
                Enum.reduce(calls, 0,
                  fn({:phone, _number, sd, st, ed, et}, minutes_of_conversation) ->
                    minutes_of_conversation + minutes_between({sd, st}, {ed, et})
                  end)
              }
            end)
  end

  defp minutes_between({sd, st}, {ed, et}) do
    div(abs(datetime_to_seconds(ed, et) - datetime_to_seconds(sd, st)) + 59, 60)
  end

  defp datetime_to_seconds(date, time) do
    [year,month,day] = String.split(date, "-")
      |> Enum.map(fn(n) -> Regex.replace(~r/^0?/, n, "") end)
      |> Enum.map(&String.to_integer/1)
    [hour,minute,second] = String.split(time, ":")
      |> Enum.map(fn(n) -> Regex.replace(~r/^0?/, n, "") end)
      |> Enum.map(&String.to_integer/1)
    :calendar.datetime_to_gregorian_seconds({{year, month, day}, {hour, minute, second}})
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

  test "summary for all telephone numbers" do
    Phone.ETS.setup("ch11-01-calls.csv")
    assert (Phone.ETS.summary |> Enum.sort) == [
      {"213-555-0172",9},
      {"301-555-0433",12},
      {"415-555-7871",7},
      {"650-555-3326",11},
      {"729-555-8855",6},
      {"838-555-1099",9},
      {"946-555-9760",3}
    ]
  end

  test "summary for a telephone numbers" do
    Phone.ETS.setup("ch11-01-calls.csv")
    assert Phone.ETS.summary("213-555-0172") == {"213-555-0172",9}
  end
end

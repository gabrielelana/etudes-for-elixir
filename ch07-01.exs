# Your local college has given you a text file that contains data about which
# courses are taught in which rooms. Here is part of the file. The first column
# is the course ID number. The second column is the course name, and the third
# column is the room number.
#
# 64850,ENGL 033,RF141
# 64851,ENGL 080,SC103
# 64853,ENGL 102,C101B
#
# Your job in this étude is to read the file and create a HashDict whose key is
# the room number and whose value is a list of all the courses taught in that
# room.

defmodule College do

  @doc """
  Open a file with columns course ID, name, and room.
  Construct a HashDict with the room as a key and the courses
  taught in that room as the value.
  """
  @spec room_list_from(String.t) :: HashDict.t

  def room_list_from(file_path) do
    File.stream!(file_path, [:read, :utf8]) |>
      Enum.map(&split(&1)) |>
      Enum.reduce(HashDict.new, &group_by(&1, &2))
  end

  defp split(line) do
    line |> String.split(~r/[,\n]/, trim: true)
  end

  defp group_by([_id, course, room], room_list) do
    case HashDict.get(room_list, room) do
      nil -> HashDict.put_new(room_list, room, [course])
      course_list -> HashDict.put(room_list, room, [course | course_list])
    end
  end
end

ExUnit.start

defmodule CollegeTest do
  use ExUnit.Case, async: true

  test "read from csv" do
    room_list = College.room_list_from("ch07-01-courses.csv")
    assert [
      "A2211", "A4213", "A4231", "AD211", "AD221", "AF231", "C101A", "C101B", "C102",
      "C103", "C104", "C105", "C202", "C203", "P104A", "PE105", "PE202", "PE204",
      "RD301", "RD312", "RE301", "RE311", "RF141", "RF234", "RF241", "RG122",
      "RG248", "S140", "S160", "SC103", "SC125", "VPA125F", "VPA200", "VPA201",
      "VPA203"
    ] == HashDict.keys(room_list) |> Enum.sort
  end
end

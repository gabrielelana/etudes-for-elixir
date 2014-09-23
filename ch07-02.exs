# You will read a CSV (comma-separated values) file with information about
# countries and cities, Lines with two entries give a country name and its
# primary language; lines with four entries give a city name, its population, its
# latitude, and its longitude. Here is some sample data
#
# Germany,German
# Hamburg,1739117,53.57532,10.01534
# Frankfurt am Main,650000,50.11552,8.68417
# Dresden,486854,51.05089,13.73832
# Spain,Spanish
# Madrid,3255944,40.4165,-3.70256
# Granada,234325,37.18817,-3.60667
# Barcelona,1621537,41.38879,2.15899
# South Korea,Korean
# Seoul,10349312,37.56826,126.97783
# Busan,3678555,35.10278,129.04028
# Daegu,2566540,35.87028,128.59111
# Peru,Spanish
# Lima,7737002,-12.04318,-77.02824
# Cusco,312140,-13.52264,-71.96734
# Arequipa,841130,-16.39889,-71.535
#
# Define two structures. The first one, Country has fields for the country name,
# its language, and a list of cities in that country. Each of the cities is
# represented by a City structure, which has fields for the city name,
# population, latitude, and longitude. This is something new: a structure that
# has structures in it

defmodule Country do
  defstruct name: "", language: "", cities: []
end

defmodule City do
  defstruct name: "", population: 0, latitude: 0.0, longitude: 0.0
end

defmodule Geography do

  @doc """
  Open a file with columns country code, city, population, latitude, and
  longitude. Construct a Country structure for each country containing the
  cities in that country.
  """

  @spec read(String.t) :: [Country.t]

  def read(file_path) do
    File.stream!(file_path, [:read, :utf8])
      |> Enum.map(&(String.split(&1, ~r/[,\n]/, trim: true)))
      |> Enum.reduce([], &to_struct/2)
      |> Enum.map(fn country = %Country{cities: cities} -> %{country | cities: Enum.reverse(cities)} end)
      |> Enum.reverse
  end

  defp to_struct([name, language], countries) do
    [%Country{name: name, language: language} | countries]
  end

  defp to_struct([name, population, latitude, longitude], [country | countries]) do
    city = %City{
      name: name,
      population: String.to_integer(population),
      latitude: String.to_float(latitude),
      longitude: String.to_float(longitude)
    }
    country = %{country | cities: [city | country.cities]}
    [country | countries]
  end
end


ExUnit.start

defmodule GeographyTest do
  use ExUnit.Case, async: true

  test "read countries and cities from csv" do
    countries = Geography.read("ch07-02-geography.csv")
    assert ["Germany", "Spain", "South Korea", "Peru"] == (
      countries |> Enum.map(fn %Country{name: name} -> name end)
    )
    assert ["Hamburg", "Dresden", "Madrid", "Barcelona", "Seoul", "Daegu", "Lima", "Arequipa"] == (
      countries
        |> Enum.map(fn %Country{cities: cities} -> cities end)
        |> List.flatten
        |> Enum.map(fn %City{name: name} -> name end)
    )
  end
end

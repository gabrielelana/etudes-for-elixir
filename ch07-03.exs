# Add a function population_by_language/2 to the Geography module. The first argument
# will be a list as constructed by read/1, and the second argument is
# a string giving the name of a language. The function returns the total
# population of all the cities in countries whose primary language is the one
# you specified

defmodule Country do
  defstruct name: "", language: "", cities: []
end

defmodule City do
  defstruct name: "", population: 0, latitude: 0.0, longitude: 0.0
end

defmodule Geography do

  @doc """
  Total population of all cities in all countries that speaks a given language
  """

  @spec population_by_language(Country.t, String.t) :: integer()

  def population_by_language(countries, language) do
    countries
      |> Enum.filter(&(&1.language == language))
      |> Enum.map(&(&1.cities))
      |> List.flatten
      |> Enum.reduce(0, &(&2 + &1.population))

    # Alternative solutions

    # countries
    #   |> Enum.filter(fn(country) -> country.language == language end)
    #   |> Enum.map(fn(country) -> country.cities end)
    #   |> List.flatten
    #   |> Enum.reduce(0, fn(city, population) -> population + city.population end)

    # countries
    #   |> Enum.filter(fn(country) -> country.language == language end)
    #   |> Enum.reduce(0,
    #     fn(country, total) -> total +
    #       Enum.reduce(country.cities, 0, fn(city, total) -> total + city.population end)
    #     end
    #   )

    # countries |> Enum.reduce(0, fn(country = %Country{}, total) ->
    #   total +
    #     case country.language do
    #       ^language -> country.cities
    #         |> Enum.reduce(0, fn(%City{population: population}, total) -> total + population end)
    #       _ -> 0
    #     end
    # end)

    # This one doesn't work but I don't know why, says that language is not
    # bound but it should be

    # countries |> Enum.reduce(0,
    #   fn
    #     (country = %Country{language: ^language}, total) ->
    #       total + Enum.reduce(country.cities, 0, fn(city, total) -> total + city.population end)
    #     (_, population) -> population
    #   end
    # )
  end

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

  test "population_by_language/2" do
    countries = Geography.read("ch07-02-geography.csv")
    assert Geography.population_by_language(countries, "Korean") == 12915852
  end
end

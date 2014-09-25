# Add a new protocol to check to see if a City is valid. To be valid, the
# population must be greater than or equal to zero, the latitude must be
# between -90 and 90 (inclusive), and the longitude between -180 and 180
# (inclusive). Your protocol will implement the valid?/1 function.

defmodule City do
  defstruct name: "", population: 0, latitude: 0.0, longitude: 0.0
end

defprotocol Valid do
  @doc "Returns true if data is to be considered valid"
  def valid?(data)
end

defimpl Valid, for: City do
  def valid?(city) do
    (city.name |> String.strip |> String.length > 0) and
    (city.population >= 0) and
    (city.latitude >= -90 and city.latitude <= 90) and
    (city.longitude >= -180 and city.longitude <= 180)
  end
end

defimpl Inspect, for: City do
  import Inspect.Algebra

  def inspect(city, _options) do
    latitude = if (city.latitude < 0) do
      concat(to_string(Float.round(abs(city.latitude), 2)), "°S")
    else
      concat(to_string(Float.round(city.latitude, 2)), "°N")
    end

    longitude = if (city.longitude < 0) do
      concat(to_string(Float.round(abs(city.longitude), 2)), "°W")
    else
      concat(to_string(Float.round(city.longitude, 2)), "°E")
    end

    concat([
      city.name, break,
      "(", to_string(city.population), ")", break,
      latitude, break, longitude
    ])
  end
end


ExUnit.start

defmodule CityTest do
  use ExUnit.Case, async: true
  import ExUnit.CaptureIO

  test "default City is not a valid" do
    assert Valid.valid?(%City{}) == false
  end

  test "City with a name is valid" do
    assert Valid.valid?(%City{name: "Milano"}) == true
  end

  test "City population must be greater than or equal to zero" do
    assert Valid.valid?(%City{name: "Milano", population: 0}) == true
    assert Valid.valid?(%City{name: "Milano", population: -0}) == true
    assert Valid.valid?(%City{name: "Milano", population: 42}) == true
    assert Valid.valid?(%City{name: "Milano", population: -1}) == false
  end

  test "City latitude must be between -90 and 90 inclusive" do
    assert Valid.valid?(%City{name: "Milano", latitude: -91}) == false
    assert Valid.valid?(%City{name: "Milano", latitude: -90}) == true
    assert Valid.valid?(%City{name: "Milano", latitude: -42}) == true
    assert Valid.valid?(%City{name: "Milano", latitude: 0}) == true
    assert Valid.valid?(%City{name: "Milano", latitude: 42}) == true
    assert Valid.valid?(%City{name: "Milano", latitude: 90}) == true
    assert Valid.valid?(%City{name: "Milano", latitude: 91}) == false
  end

  test "City longitude must be between -180 and 180 inclusive" do
    assert Valid.valid?(%City{name: "Milano", longitude: -181}) == false
    assert Valid.valid?(%City{name: "Milano", longitude: -180}) == true
    assert Valid.valid?(%City{name: "Milano", longitude: -42}) == true
    assert Valid.valid?(%City{name: "Milano", longitude: 0}) == true
    assert Valid.valid?(%City{name: "Milano", longitude: 42}) == true
    assert Valid.valid?(%City{name: "Milano", longitude: 180}) == true
    assert Valid.valid?(%City{name: "Milano", longitude: 181}) == false
  end

  test "Inspect" do
    city = %City{name: "Hamburg", population: 1739117, latitude: 53.57532, longitude: 10.01534}
    assert capture_io(fn -> IO.inspect(city) end) == "Hamburg (1739117) 53.58°N 10.02°E\n"

    city = %City{name: "Lima", population: 7737002, latitude: -16.39889, longitude: -77.535}
    assert capture_io(fn -> IO.inspect(city) end) == "Lima (7737002) 16.4°S 77.54°W\n"
  end
end

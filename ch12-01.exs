defmodule Weather.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [], [{:name, __MODULE__}])
  end

  def init([]) do
    supervise(
      _children = [
        worker(Weather, [])
      ],
      _with_options = [
        {:strategy, :one_for_one},
        {:max_restarts, 1},
        {:max_seconds, 5},
      ]
    )
  end
end

defmodule Weather do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, [], [{:name, __MODULE__}])
  end

  def init([]) do
    :inets.start()
    {:ok, []}
  end

  def handle_call({:report_from, weather_station}, _from, data) do
    {reply, data} = fetch(weather_station, data)
    {:reply, reply, data}
  end

  defp fetch(weather_station, data) do
    url = "http://w1.weather.gov/xml/current_obs/#{weather_station}.xml"
    case :httpc.request(to_char_list(url)) do
      {:error, e} ->
        {{:error, e}, data}
      {:ok, {{_http, 200, _message}, _headers, body}} ->
        {
          {:ok, fetch_fields_from(body)},
          Enum.take([weather_station | data], 10)
        }
      {:ok, {{_http, code, _message}, _headers, _}} ->
        {{:error, code}, data}
    end
  end

  defp fetch_fields_from(xml) when is_list(xml), do: fetch_fields_from(to_string(xml))
  defp fetch_fields_from(xml) do
    for field <- [:location, :observation_time_rfc822, :weather, :temperature_string] do
      fetch_field_from(field, xml)
    end
  end

  defp fetch_field_from(field, xml) do
    {:ok, pattern} = Regex.compile("<#{field}>([^<]+)</#{Atom.to_string(field)}>")
    case Regex.run(pattern, xml) do
      [_, match] -> {field, match}
      nil -> {field, nil}
    end
  end
end


ExUnit.start

defmodule Weather.Test do
  use ExUnit.Case

  test "shall pass" do
    {:ok, pid} = Weather.Supervisor.start_link
    Process.unlink(pid)

    assert(
      {:ok, [location: _, observation_time_rfc822: _, weather: _, temperature_string: _]}
      =
      GenServer.call(Weather, {:report_from, "KGAI"})
    )
  end
end

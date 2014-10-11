defmodule Chatroom do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, HashDict.new, [{:name, __MODULE__}])
  end

  def login(name) do
    GenServer.call(__MODULE__, {:login, name})
  end

  def logout_of(user) do
    GenServer.call(__MODULE__, {:logout, user})
  end

  def say(user) do
  end

  def users do
    GenServer.call(__MODULE__, :users)
  end

  def profile_of(user) do
  end

  # GenServer callbacks

  def init(users) do
    {:ok, users}
  end

  def handle_call({:login, name}, {pid, _ref}, users) do
    users = Dict.put(users, name, %{pid: pid, name: name, profile: []})
    {:reply, :ok, users}
  end
  def handle_call(:users, _from, users) do
    {:reply, {:users, Dict.to_list(users)}, users}
  end
end

defmodule Chatroom.User do

  def start_link(name) do
  end

  def login(user) do
  end

  def logout(user) do
  end

  def say(user, message) do
  end

  def add_to_profile(user, key, value) do
  end

  def whois(name) do
  end

  def users do
  end
end


ExUnit.start

defmodule Chatroom.Test do
  use ExUnit.Case

  test "login" do
    Chatroom.start_link
    assert :ok == Chatroom.login("Gabriele")
    assert {:users, [{"Gabriele", %{pid: self(), name: "Gabriele", profile: []}}]} == Chatroom.users
  end
end

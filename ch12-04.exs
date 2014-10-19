defmodule Chatroom do
  use GenServer
  alias Chatroom.User

  @spec start_link :: {:ok, pid} | {:error, term}
  def start_link do
    GenServer.start_link(__MODULE__, HashDict.new, [{:name, __MODULE__}])
  end

  @spec login(pid, String.t) :: :ok | {:error, term}
  def login(user, name) do
    GenServer.call(__MODULE__, {:login, user, name})
  end

  @spec logout(pid) :: :ok | {:error, term}
  def logout(user) do
    GenServer.call(__MODULE__, {:logout, user})
  end

  @spec say(pid, String.t) :: :ok | {:error, term}
  def say(user, message) do
    GenServer.call(__MODULE__, {:say, user, message})
  end

  def users do
    GenServer.call(__MODULE__, :users)
  end

  def whois(name) do
    GenServer.call(__MODULE__, {:whois, name})
  end

  # GenServer callbacks

  def init(users) do
    {:ok, users}
  end

  def handle_call({:login, pid, name}, {pid, _ref}, users) do
    users = Dict.put(users, pid, %{pid: pid, name: name})
    {:reply, :ok, users}
  end
  def handle_call({:logout, pid}, {pid, _ref}, users) do
    {%{pid: ^pid, name: _}, users} = Dict.pop(users, pid)
    {:reply, :ok, users}
  end
  def handle_call({:say, pid, message}, {pid, _ref}, users) do
    %{pid: ^pid, name: name} = Dict.get(users, pid)
    Dict.values(users) |> Enum.each(
      fn(%{pid: user, name: _}) ->
        case user do
          ^pid -> :do_not_send_back_message_to_yourself
          _ -> User.message(user, name, message)
        end
      end
    )
    {:reply, :ok, users}
  end
  def handle_call(:users, _from, users) do
    {:reply, {:users, Dict.to_list(users)}, users}
  end
  def handle_call({:whois, name}, _from, users) do
    %{pid: pid, name: _} =
      Dict.values(users) |> Enum.find(
        fn(%{pid: _, name: an_user_name}) ->
          an_user_name == name
        end
      )
    {:reply, User.whois(pid, name), users}
  end
end

defmodule Chatroom.User do

  @spec start_link(String.t, {atom, pid}) :: {:ok, pid} | {:error, term}
  def start_link(name, {display_module, display_pid}) do
    GenServer.start_link(__MODULE__, [name, {display_module, display_pid}])
  end

  def login(user) do
    GenServer.call(user, :login)
  end

  def logout(user) do
    GenServer.call(user, :logout)
  end

  def say(user, message) do
    GenServer.call(user, {:say, message})
  end

  def message(user, name, message) do
    GenServer.call(user, {:message, name, message})
  end

  def profile(user, key, value) do
    GenServer.call(user, {:profile, key, value})
  end

  def whois(user, name) do
    GenServer.call(user, {:whois, name})
  end

  def users do
  end

  # GenServer callbacks

  def init([name, {display_module, display_pid}]) do
    {:ok, %{name: name, display: {display_module, display_pid}, profile: HashDict.new}}
  end

  def handle_call(:login, _from, status = %{name: name}) do
    Chatroom.login(self(), name)
    {:reply, :ok, status}
  end
  def handle_call(:logout, _from, status) do
    Chatroom.logout(self())
    {:reply, :ok, status}
  end
  def handle_call({:say, message}, _from, status = %{display: {display_module, display_pid}}) do
    display_module.show(display_pid, "Me: #{message}")
    Chatroom.say(self(), message)
    {:reply, :ok, status}
  end
  def handle_call({:message, name, message}, _from, status = %{display: {display_module, display_pid}}) do
    display_module.show(display_pid, "#{name}: #{message}")
    {:reply, :ok, status}
  end
  def handle_call({:profile, key, value}, _from, status = %{profile: profile}) do
    {:reply, :ok, %{status | profile: Dict.put(profile, key, value)}}
  end
  def handle_call({:whois, name}, _from, status = %{name: name, profile: profile}) do
    {:reply, {:ok, profile}, status}
  end
  def handle_call({:whois, name}, _from, status = %{display: {display_module, display_pid}}) do
    {:ok, profile} = Chatroom.whois(name)
    display_module.show(display_pid, "#{name}: #{inspect Dict.to_list(profile)}")
    {:reply, {:ok, profile}, status}
  end

  def handle_cast(_msg, state) do
    {:noreply, state}
  end
  def handle_info(_info, state) do
    {:noreply, state}
  end
  def terminate(_reason, _state) do
    {:ok}
  end
  def code_change(_old_version, state, _extra) do
    {:ok, state}
  end
end


ExUnit.start

defmodule Chatroom.Test do
  use ExUnit.Case
  alias Chatroom.User

  defmodule Display do
    def start_link do
      GenServer.start_link(__MODULE__, [])
    end
    def show(display, message) do
      GenServer.call(display, {:show, message})
    end
    def messages(display) do
      GenServer.call(display, :messages)
    end

    def init([]) do
      {:ok, []}
    end
    def handle_call({:show, message}, _from, messages) do
      {:reply, :ok, [message|messages]}
    end
    def handle_call(:messages, _from, messages) do
      {:reply, Enum.reverse(messages), messages}
    end

    def handle_cast(_msg, state) do
      {:noreply, state}
    end
    def handle_info(_info, state) do
      {:noreply, state}
    end
    def terminate(_reason, _state) do
      {:ok}
    end
    def code_change(_old_version, state, _extra) do
      {:ok, state}
    end
  end

  test "login" do
    Chatroom.start_link
    assert :ok == Chatroom.login(self(), "Gabriele")
    assert {:users, [{self(), %{pid: self(), name: "Gabriele"}}]} == Chatroom.users
  end

  test "logout" do
    Chatroom.start_link
    assert :ok == Chatroom.login(self(), "Gabriele")
    assert :ok == Chatroom.logout(self())
    assert {:users, []} == Chatroom.users
  end

  test "send a message" do
    Chatroom.start_link
    {:ok, gabriele_display} = Display.start_link
    {:ok, gabriele} = User.start_link("Gabriele", {Display, gabriele_display})
    {:ok, chiara_display} = Display.start_link
    {:ok, chiara} = User.start_link("Chiara", {Display, chiara_display})

    User.login(gabriele)
    User.login(chiara)
    User.say(gabriele, "Hello everybody")

    assert Display.messages(gabriele_display) == ["Me: Hello everybody"]
    assert Display.messages(chiara_display) == ["Gabriele: Hello everybody"]
  end

  test "whois" do
    Chatroom.start_link
    {:ok, gabriele_display} = Display.start_link
    {:ok, gabriele} = User.start_link("Gabriele", {Display, gabriele_display})
    {:ok, chiara_display} = Display.start_link
    {:ok, chiara} = User.start_link("Chiara", {Display, chiara_display})

    User.login(gabriele)
    User.login(chiara)
    User.profile(gabriele, :age, 37)

    User.whois(chiara, "Gabriele")
    assert Display.messages(chiara_display) == ["Gabriele: [age: 37]"]
  end
end

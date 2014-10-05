# Two players each take 26 cards from a shuffled deck. Each person puts her top
# card face up on the table. Whoever has the higher value card wins that
# battle, takes both cards, and puts them at the bottom of her stack. What
# happens if the cards have the same value? Then the players go to "war." Each
# person puts the next two cards from their stack face down in the pile and a
# third card face up. High card wins, and the winner takes all the cards for
# the bottom of her stack. If the cards match again, the war continues with
# another set of three cards from each person. If a person has fewer than three
# cards when a war happens, he puts in all his cards.

defmodule Dealer do
  defstruct players: [], flipped: [], turned: []

  def start_link do
    spawn_link __MODULE__, :waiting_for_players, [%Dealer{}]
  end

  def waiting_for_players(dealer = %Dealer{players: []}) do
    IO.puts("Dealer: waiting for players")
    receive do
      {:join, player} ->
        IO.puts("Dealer: first player joined the game")
        waiting_for_players(%Dealer{dealer | players: [player]})
    end
  end
  def waiting_for_players(dealer = %Dealer{players: [_]}) do
    IO.puts("Dealer: waiting for player")
    receive do
      {:join, player} ->
        IO.puts("Dealer: second and last player joined the game")
        give_cards(%Dealer{dealer | players: [player | dealer.players]})
    end
  end

  def give_cards(dealer) do
    IO.puts("Dealer: give both players their cards")
    deck = Deck.new |> Deck.shuffle
    {d1, d2} = Enum.split(deck, trunc(Enum.count(deck) / 2))
    [p1, p2] = dealer.players
    send(p1, {:deck, d1})
    send(p2, {:deck, d2})
    ask_for_cards(dealer)
  end

  def ask_for_cards(dealer = %Dealer{turned: []}) do
    IO.puts("Dealer: ask both player to flip a card")
    [p1, p2] = dealer.players
    send(p1, {:flip, self()})
    send(p2, {:flip, self()})
    waiting_for_cards(dealer)
  end
  def ask_for_cards(dealer) do
    IO.puts("Dealer: ask both player to flip two cards")
    [p1, p2] = dealer.players
    send(p1, {:flip, 2, self()})
    send(p2, {:flip, 2, self()})
    waiting_for_cards(dealer)
  end

  def waiting_for_cards(dealer = %Dealer{flipped: []}) do
    receive do
      {:card, card, p} ->
        waiting_for_cards(%Dealer{dealer | flipped: [{card, p}]})
      {:cards, flipped, turned, p} ->
        waiting_for_cards(
          %Dealer{dealer |
            flipped: [{flipped, p}],
            turned: [{turned, p} | dealer.turned]
          }
        )
      {:out, looser} ->
        [winner] = dealer.players -- [looser]
        send(winner, :win)
        send(looser, :loose)
    end
  end
  def waiting_for_cards(dealer) do
    receive do
      {:card, card, p} ->
        evaluate(%Dealer{dealer | flipped: [{card, p} | dealer.flipped]})
      {:cards, flipped, turned, p} ->
        evaluate(
          %Dealer{dealer |
            flipped: [{flipped, p} | dealer.flipped],
            turned: [{turned, p} | dealer.turned]
          }
        )
      {:out, looser} ->
        [winner] = dealer.players -- [looser]
        send(winner, :win)
        send(looser, :loose)
    end
  end

  def evaluate(dealer) do
    [{c1, p1}, {c2, p2}] = dealer.flipped
    case Deck.Card.compare(c1, c2) do
      n when n > 0 ->
        IO.puts("Dealer: #{inspect c1} is the winner")
        send(p1, {:win, (dealer.flipped ++ dealer.turned) |> only_cards()})
        ask_for_cards(%Dealer{dealer | flipped: [], turned: []})
      n when n < 0 ->
        IO.puts("Dealer: #{inspect c2} is the winner")
        send(p2, {:win, (dealer.flipped ++ dealer.turned) |> only_cards()})
        ask_for_cards(%Dealer{dealer | flipped: [], turned: []})
      _ ->
        IO.puts("Dealer: it's a draw, we are going to war!")
        ask_for_cards(%Dealer{dealer | flipped: [], turned: dealer.flipped ++ dealer.turned})
    end
  end

  defp only_cards(cards_and_players) do
    cards_and_players |> Enum.map(fn {c, p} -> c end)
  end
end

defmodule Player do
  defstruct name: "unknown", deck: []

  def start_link(name) do
    spawn_link __MODULE__, :waiting_to_play, [%Player{name: name}]
  end

  def play_with(player, dealer) do
    send(dealer, {:join, player})
  end

  def waiting_to_play(player) do
    say(player, "waiting to play")
    receive do
      {:deck, deck} ->
        say(player, "received my deck, ready to play")
        play(%Player{player | deck: deck})
    end
  end

  def play(player) do
    receive do
      {:flip, dealer} ->
        case player.deck do
          [card | deck] ->
            say(player, "flipped #{inspect card}")
            send(dealer, {:card, card, self()})
            play(%Player{player | deck: deck})
          [] ->
            say(player, "I'm out of cards!!!")
            send(dealer, {:out, self()})
            play(player)
        end
      {:flip, 2, dealer} ->
        case player.deck do
          [flipped, turned | deck] ->
            say(player, "flipped #{inspect flipped} + another turned card")
            send(dealer, {:cards, flipped, turned, self()})
            play(%Player{player | deck: deck})
          [_ | deck] ->
            say(player, "I'm out of cards!!!")
            send(dealer, {:out, self()})
            play(player)
          [] ->
            say(player, "I'm out of cards!!!")
            send(dealer, {:out, self()})
            play(player)
        end
      {:win, cards} ->
        say(player, "won #{inspect cards}")
        play(
          %Player{player | deck:
            Enum.reverse(Enum.reverse(cards) ++ Enum.reverse(player.deck))
          }
        )
      :win ->
        say(player, ":-)")
      :loose ->
        say(player, ":-(")
    end
  end

  defp say(player, message) do
    IO.puts("Player #{player.name}: #{message}")
  end
end

defmodule Deck do

  defmodule Card do
    @type suit :: :clubs | :diamonds | :hearts | :spades
    @type rank :: :ace | :king | :queen | :jack | 1..10
    @type t :: {rank, suit}

    @suits [:clubs, :diamonds, :hearts, :spades]
    @ranks [:ace, :king, :queen, :jack, 10, 9, 8, 7, 6, 5, 4, 3, 2]

    @spec suits() :: [suit]
    def suits, do: @suits

    @spec ranks() :: [rank]
    def ranks, do: @ranks

    @spec sorter(t, t) :: boolean
    def sorter({lr, _}, {rr, _}) do
      rank_of(lr) <= rank_of(rr)
    end

    @spec compare(t, t) :: number
    def compare({lr, _}, {rr, _}) do
      rank_of(lr) - rank_of(rr)
    end

    defp rank_of(:ace), do: 14
    defp rank_of(:king), do: 13
    defp rank_of(:queen), do: 12
    defp rank_of(:jack), do: 11
    defp rank_of(n) when is_integer(n) and n in 1..10, do: n
  end

  alias Deck.Card

  @type t :: [Card.t]

  @cards for rank <- Card.ranks, suit <- Card.suits, do: {rank, suit}

  @spec new() :: t
  def new do
    @cards
  end

  @spec shuffle(t) :: t
  def shuffle(deck, seed \\ :os.timestamp) do
    :random.seed(seed)
    Enum.shuffle(deck)
  end
end

dealer = Dealer.start_link()
p1 = Player.start_link("Gabriele")
p2 = Player.start_link("Chiara")
p1 |> Player.play_with(dealer)
p2 |> Player.play_with(dealer)

# The goal of this étude is to write the documentation for the algorithm. If
# you aren’t sure what the code does

defmodule Cards do

  @doc """
  Shuffles a deck of cards.

  Starts with a list of cards and an empty list
  The first argument is the ordered list of cards, the second is the shuffled list of cards
  Selects a random element from the list of cards, the random element will be removed from the ordered list of cards and appended to the shuffled list of cards
  Calls itself recursively
  When the ordered list of cards is empty then the shuffled list of cards is completed
  """

  def shuffle(list) do
    :random.seed(:erlang.now())
    shuffle(list, [])
  end

  def shuffle([], acc) do
    acc
  end

  def shuffle(list, acc) do
    {leading, [h | t]} = Enum.split(list, :random.uniform(Enum.count(list)) - 1)
    shuffle(leading ++ t, [h | acc])
  end

  # Alternative implementation

  # def shuffle(cards) do
  #   :random.seed(:erlang.now())
  #   Stream.repeatedly(&:random.uniform/0)
  #     |> Enum.take(Enum.count(cards))
  #     |> Enum.zip(cards)
  #     |> Enum.sort(fn({rl, _}, {rr, _}) -> rl < rr end)
  #     |> Enum.map(fn({_, card}) -> card end)
  # end
end

ExUnit.start

defmodule CardsTest do

  @deck [
    {:ace, :clubs}, {:ace, :diamonds}, {:ace, :hearts}, {:ace, :spades},
    {2, :clubs}, {2, :diamonds}, {2, :hearts}, {2, :spades},
    {3, :clubs}, {3, :diamonds}, {3, :hearts}, {3, :spades},
    {4, :clubs}, {4, :diamonds}, {4, :hearts}, {4, :spades},
    {5, :clubs}, {5, :diamonds}, {5, :hearts}, {5, :spades},
    {6, :clubs}, {6, :diamonds}, {6, :hearts}, {6, :spades},
    {7, :clubs}, {7, :diamonds}, {7, :hearts}, {7, :spades},
    {8, :clubs}, {8, :diamonds}, {8, :hearts}, {8, :spades},
    {9, :clubs}, {9, :diamonds}, {9, :hearts}, {9, :spades},
    {10, :clubs}, {10, :diamonds}, {10, :hearts}, {10, :spades},
    {:jack, :clubs}, {:jack, :diamonds}, {:jack, :hearts}, {:jack, :spades},
    {:queen, :clubs}, {:queen, :diamonds}, {:queen, :hearts}, {:queen, :spades},
    {:king, :clubs}, {:king, :diamonds}, {:king, :hearts}, {:king, :spades}
  ]

  use ExUnit.Case

  test "shuffles a deck of cards" do
    assert Cards.shuffle(@deck) != @deck
  end
end

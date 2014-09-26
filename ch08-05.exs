# Write a module named Cards that contains a function make_deck/0. The function
# will use a list comprehension with two generators to create a deck of cards
# as a list 52 tuples

defmodule Cards do
  @ranks [:ace, 2, 3, 4, 5, 6, 7, 8, 9, 10, :jack, :queen, :king]
  @suits [:clubs, :diamonds, :hearts, :spades]

  def deck do
    for rank <- @ranks, suit <- @suits, do: {rank, suit}
  end
end

ExUnit.start

defmodule CardsTest do
  use ExUnit.Case

  test "makes a deck of cards" do
    assert Cards.deck == [
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
  end
end

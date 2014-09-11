# In this étude, create a module named Random, and write a function
# generate_pockets/2. This function has a character list consisting of T and F
# for its first argument. A T in the list indicates that the tooth is present,
# and a F indicates a missing tooth. This will be a single quoted character list,
# so you can treat it just as you would any other list. Remember to refer to
# individual characters as ?T and ?F.
#
# The second argument is a floating point number between 0 and 1.0 that indicates
# the probability that a tooth will be a good tooth.
#
# The result is a list of lists, one list per tooth. If a tooth is present, the
# sublist has six entries; if a tooth is absent, the sublist is [0].

defmodule Random do

  @doc """
  Generate a list of list representing pocket depths for a set of teeth.
  The first argument is a character list consisting of T and F for teeth
  that are present or absent. The second argument is the probability that
  any given tooth will be good.
  """
  @spec generate_pockets(list, number) :: list(list)

  def generate_pockets(teeth, probability) do
    initialize_random_number_generator
    Enum.zip(teeth, (for _ <- 1..length(teeth), do: probability))
      |> Enum.map(&generate_tooth/1)
  end

  defp generate_tooth({?F, _}) do
    [0]
  end
  defp generate_tooth({?T, probability}) do
    depth = if :random.uniform() <= probability, do: 3, else: 4
    Enum.map(1..6, fn _ -> :random.uniform(depth) end)
  end

  defp initialize_random_number_generator do
    :random.seed(:erlang.now())
  end
end

ExUnit.start

defmodule RandomTest do
  use ExUnit.Case, async: true

  test "shall pass" do
    pockets = Random.generate_pockets('FTTTTTTTTTTTTTTFTTTTTTTTTTTTTTTT', 0.75)
    number_of_teeth = length(pockets |> Enum.filter(&(length(&1) == 6)))
    number_of_good_teeth = length(
      pockets
        |> Enum.filter(&(length(&1) == 6))
        |> Enum.filter(&(Enum.all?(&1, fn(d) -> d < 4 end)))
      )
    assert_in_delta (number_of_teeth * 0.75), number_of_good_teeth, 5
  end
end

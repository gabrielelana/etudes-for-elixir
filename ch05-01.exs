defmodule Geom do

  @spec area(atom(), number(), number()) :: number()

  def area(shape, a, b) when a >= 0 and b >= 0 do
    case shape do
      :rectangle -> a * b
      :triangle -> a * b  / 2.0
      :ellipse -> :math.pi * a * b
    end
  end

  defmodule UI do
    @moduledoc """
    Validates input.
    """
    @vsn 0.1

    @doc """
    Requests a character for the name of a shape, numbers for its dimensions, and
    calculates shape's area. The characters are R for rectangle, T for triangle,
    and E for ellipse. Input is allowed in either upper or lower case. For
    unknown shapes, the first "dimension" will be the unknown character.
    """

    @spec area() :: number()

    def area() do
      input = IO.gets("R)ectangle, T)riangle, or E)llipse: ")
      shape = char_to_shape(String.first(input))
      {d1, d2} = case shape do
        :rectangle -> aks_for_dimensions("width", "height")
        :triangle -> aks_for_dimensions("base ", "height" )
        :ellipse -> aks_for_dimensions("major radius", "minor radius")
        :unknown -> {String.first(input), 0}
      end
      calculate(shape, d1, d2)
    end


    @spec char_to_shape(char()) :: atom()

    defp char_to_shape(character) do
      cond do
        String.upcase(character) == "R" -> :rectangle
        String.upcase(character) == "T" -> :triangle
        String.upcase(character) == "E" -> :ellipse
        true -> :unknown
      end
    end


    @spec ask_for_number(String.t()) :: number()

    defp ask_for_number(prompt) do
      IO.gets("Enter #{prompt} > ") |> String.strip |> String.to_integer
    end


    @spec aks_for_dimensions(String.t(), String.t()) :: {number(), number()}

    defp aks_for_dimensions(prompt1, prompt2) do
      n1 = ask_for_number(prompt1)
      n2 = ask_for_number(prompt2)
      {n1, n2}
    end


    @spec calculate(atom(), number(), number()) :: number()

    defp calculate(shape, d1, d2) do
      cond do
        shape == :unknown -> IO.puts("Unknown shape #{d1}.")
        d1 < 0 or d2 < 0  -> IO.puts("Both numbers must be greater than or equal to zero.")
        true              -> Geom.area(shape, d1, d2)
      end
    end
  end
end

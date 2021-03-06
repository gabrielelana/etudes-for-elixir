# In this étude, you will use regular expressions to make sure that input is
# numeric and to distinguish integers from floating point numbers. You need to
# do this because binary_to_float/1 will not accept a string like "1812" as an
# argument


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
        :triangle -> aks_for_dimensions("base", "height" )
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
      IO.gets("Enter #{prompt} > ") |> String.strip |> (&(
        cond do
          Regex.match?(~r/^[-+]?\d+\.\d+([eE][-+]?\d+)?$/, &1) -> String.to_float(&1)
          Regex.match?(~r/^[-+]?\d+$/, &1) -> String.to_integer(&1)
          true -> {:not_a_number, &1}
        end
      )).()
    end


    @spec aks_for_dimensions(String.t(), String.t()) :: {number(), number()}

    defp aks_for_dimensions(prompt1, prompt2) do
      n1 = ask_for_number(prompt1)
      n2 = ask_for_number(prompt2)
      {n1, n2}
    end


    @spec calculate(atom(), number(), number()) :: number()

    defp calculate(shape, d1, d2) do
      case {shape, d1, d2} do
        {:unknown, _, _} -> IO.puts("Unknown shape '#{d1}'.")
        {_, {:not_a_number, nan}, _} -> IO.puts("First dimension '#{nan}' is not a number.")
        {_, _, {:not_a_number, nan}} -> IO.puts("Second dimension '#{nan}' is not a number.")
        {_, d1, d2} when d1 < 0 or d2 < 0 -> IO.puts("Both numbers must be greater than or equal to zero.")
        {shape, d1, d2} -> IO.puts("Area: #{Geom.area(shape, d1, d2)}")
      end
    end
  end
end


ExUnit.start

defmodule GeomTest do
  use ExUnit.Case, async: true
  import ExUnit.CaptureIO

  test "numbers must be greater or equal to zero" do
    expected_interaction(
      """
      R)ectangle, T)riangle, or E)llipse: {R}
      Enter width > {-10}
      Enter height > {20}
      Both numbers must be greater than or equal to zero.
      """
    )
  end

  test "floating point numbers are good" do
    expected_interaction(
      """
      R)ectangle, T)riangle, or E)llipse: {R}
      Enter width > {10.5}
      Enter height > {20}
      Area: #{Geom.area(:rectangle, 10.5, 20)}
      """
    )
  end

  test "floating point numbers in scientific notation are good" do
    expected_interaction(
      """
      R)ectangle, T)riangle, or E)llipse: {R}
      Enter width > {10.5e+0}
      Enter height > {20}
      Area: #{Geom.area(:rectangle, 10.5e+0, 20)}
      """
    )
  end

  test "only numbers are acceptable" do
    expected_interaction(
      """
      R)ectangle, T)riangle, or E)llipse: {R}
      Enter width > {hello}
      Enter height > {20}
      First dimension 'hello' is not a number.
      """
    )
  end



  defp expected_interaction(interaction) do
    given_input = extract_input_from(interaction)
    exptected_output = extract_output_from(interaction)
    assert capture_io(given_input, fn -> Geom.UI.area end) == "#{exptected_output}\n"
  end

  defp extract_output_from(interaction) do
    interaction
      |> String.split("\n")
      |> Enum.map(
          fn(line) ->
            Regex.replace(~r/^([^{]+)({[^}]+})?$/, line, "\\1")
          end)
      |> Enum.reject(&(String.length(&1) == 0))
      |> Enum.join
  end

  defp extract_input_from(interaction) do
    interaction
      |> String.split("\n")
      |> Enum.map(
          fn(line) ->
            Regex.scan(~r/{([^}]+)}/, line)
          end)
      |> Enum.reduce([],
          fn([[_, t]], acc) -> [t|acc]
            ([], acc) -> acc
          end)
      |> Enum.reverse
      |> Enum.join("\n")
  end
end

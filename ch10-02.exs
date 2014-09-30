defmodule Bank do
  @moduledoc """
  Manipulate a "bank account" and log messages.
  """

  require Logger

  @doc """
  Create an account with a given balance.
  Repetedly asks for and peform transactions.
  """
  @spec account(number()) :: nil
  def account(balance) do
    input = IO.gets("D)eposit, W)ithdraw, B)alance, Q)uit: ")
    action = String.upcase(String.first(input))
    perform(action, balance)
  end

  defp perform("Q", _balance), do: :nothing

  defp perform("D", balance) do
    amount = ask_for_number("Amount to deposit: ")
    updated_balance = cond do
      amount > 10_000 ->
        Logger.warn("Large deposit $#{amount}")
        IO.puts("Your deposit of $#{amount} may be subject to hold")
        balance + amount
      amount < 0 ->
        Logger.error("Negative deposit $#{amount}")
        IO.puts("Deposits may not be less than zero")
        balance
      amount >= 0 ->
        Logger.info("Successful deposit $#{amount}")
        balance + amount
    end
    IO.puts("Your balance is $#{updated_balance}")
    account(updated_balance)
  end

  defp perform("W", balance) do
    amount = ask_for_number("Amount to withdraw: ")
    updated_balance = cond do
      amount > balance ->
        Logger.error("Overdraw $#{amount} from $#{balance}")
        IO.puts("You cannot withdraw more than your current balance of $#{balance}")
        balance
      amount < 0 ->
        Logger.error("Negative withdrawal $#{amount}")
        IO.puts("Withdrawals may not be less than zero")
        balance
      amount >= 0 ->
        Logger.info("Successful withdrawal $#{amount}")
        balance - amount
    end
    IO.puts("Your balance is $#{updated_balance}")
    account(updated_balance)
  end

  defp perform("B", balance) do
    Logger.info("Balance inquiry $#{balance}")
    IO.puts("Your balance is $#{balance}")
    account(balance)
  end

  defp perform(action, balance) do
    IO.puts("Unknown command #{action}")
    account(balance)
  end

  defp ask_for_number(prompt) do
    IO.gets(prompt) |> String.strip |> String.to_integer
  end
end


ExUnit.start

defmodule BankTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  test "deposit" do
    expected_interaction(
      100,
      """
      D)eposit, W)ithdraw, B)alance, Q)uit: {D}
      Amount to deposit: {100}
      Your balance is $200
      D)eposit, W)ithdraw, B)alance, Q)uit: {Q}
      """
    )
  end

  test "deposit over $10.000" do
    expected_interaction(
      100,
      """
      D)eposit, W)ithdraw, B)alance, Q)uit: {D}
      Amount to deposit: {10001}
      Your deposit of $10001 may be subject to hold
      Your balance is $10101
      D)eposit, W)ithdraw, B)alance, Q)uit: {Q}
      """
    )
  end

  test "deposit negative number" do
    expected_interaction(
      100,
      """
      D)eposit, W)ithdraw, B)alance, Q)uit: {D}
      Amount to deposit: {-10}
      Deposits may not be less than zero
      Your balance is $100
      D)eposit, W)ithdraw, B)alance, Q)uit: {Q}
      """
    )
  end

  test "inquiry" do
    expected_interaction(
      100,
      """
      D)eposit, W)ithdraw, B)alance, Q)uit: {B}
      Your balance is $100
      D)eposit, W)ithdraw, B)alance, Q)uit: {Q}
      """
    )
  end

  test "withdrawal" do
    expected_interaction(
      100,
      """
      D)eposit, W)ithdraw, B)alance, Q)uit: {W}
      Amount to withdraw: {50}
      Your balance is $50
      D)eposit, W)ithdraw, B)alance, Q)uit: {Q}
      """
    )
  end

  test "overdraw" do
    expected_interaction(
      100,
      """
      D)eposit, W)ithdraw, B)alance, Q)uit: {W}
      Amount to withdraw: {101}
      You cannot withdraw more than your current balance of $100
      Your balance is $100
      D)eposit, W)ithdraw, B)alance, Q)uit: {Q}
      """
    )
  end

  test "withdraw negative number" do
    expected_interaction(
      100,
      """
      D)eposit, W)ithdraw, B)alance, Q)uit: {W}
      Amount to withdraw: {-10}
      Withdrawals may not be less than zero
      Your balance is $100
      D)eposit, W)ithdraw, B)alance, Q)uit: {Q}
      """
    )
  end


  defp expected_interaction(balance, interaction) do
    given_input = extract_input_from(interaction)
    exptected_output = extract_output_from(interaction)
    captured_output = capture_io(given_input, fn -> Bank.account(balance) end) |> String.replace("\n", "")
    assert captured_output == exptected_output
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

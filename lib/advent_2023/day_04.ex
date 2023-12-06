defmodule Advent2023.Day04 do
  @moduledoc false

  @input Advent2023.get_input_for_day(4)

  def part_1(input \\ @input) do
    input
    |> parse_input()
    |> Enum.map(&count_winners/1)
    |> Enum.map(fn
      0 -> 0
      count -> 2 ** (count - 1)
    end)
    |> Enum.sum()
  end

  def part_2(input \\ @input) do
    input
    |> parse_input()
    |> generate_copies()
    |> Map.values()
    |> Enum.sum()
  end

  defp parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(line) do
    ["Card " <> card_number, content] = String.split(line, ": ")
    [winning, you_have] = String.split(content, " | ")

    %{
      id: card_number |> parse_numbers() |> hd(),
      numbers_you_have: parse_numbers(you_have),
      winning_numbers: parse_numbers(winning)
    }
  end

  defp parse_numbers(str) do
    str
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  defp generate_copies(original_cards) do
    starting_card_stack = original_cards |> Enum.map(& &1.id) |> Map.new(&{&1, 1})

    Enum.reduce(original_cards, starting_card_stack, fn card, stack ->
      card
      |> get_payout(stack)
      |> Map.merge(stack, fn _k, v1, v2 -> v1 + v2 end)
    end)
  end

  defp get_payout(card, stack) do
    case count_winners(card) do
      0 ->
        %{}

      winner_count ->
        qty = Map.fetch!(stack, card.id)
        card_ids = (card.id + 1)..(card.id + winner_count)
        Map.new(card_ids, &{&1, qty})
    end
  end

  defp count_winners(card) do
    Enum.count(card.numbers_you_have, &(&1 in card.winning_numbers))
  end
end

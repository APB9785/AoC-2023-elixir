defmodule Advent2023.Day07 do
  @moduledoc false

  @input Advent2023.get_input_for_day(7)

  def part_1(input \\ @input), do: solve(input, part: 1)

  def part_2(input \\ @input), do: solve(input, part: 2)

  defp solve(input, opts) do
    input
    |> parse_input()
    |> Enum.sort_by(&{hand_type(&1, opts), hand_score(&1, opts)})
    |> Enum.with_index(&Map.put(&1, :rank, &2 + 1))
    |> Enum.map(&(&1.bid * &1.rank))
    |> Enum.sum()
  end

  defp parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [hand_str, bid_str] = String.split(line, " ")
      %{hand: String.graphemes(hand_str), bid: String.to_integer(bid_str)}
    end)
  end

  defp hand_type(%{hand: hand}, opts) do
    part_2? = opts[:part] == 2
    joker_count = Enum.count(hand, fn card -> part_2? and card == "J" end)

    freqs =
      hand
      |> Enum.reject(fn card -> part_2? and card == "J" end)
      |> Enum.frequencies()
      |> Enum.sort_by(fn {_k, v} -> v end, :desc)
      |> List.update_at(0, fn {card, count} -> {card, count + joker_count} end)

    case Enum.map(freqs, fn {_card, freq} -> freq end) do
      [] -> 7
      [5] -> 7
      [4, 1] -> 6
      [3, 2] -> 5
      [3, 1, 1] -> 4
      [2, 2, 1] -> 3
      [2, 1, 1, 1] -> 2
      [1, 1, 1, 1, 1] -> 1
    end
  end

  defp hand_score(%{hand: hand}, opts) do
    Enum.map(hand, &score_card(&1, opts))
  end

  defp score_card("A", _), do: 14
  defp score_card("K", _), do: 13
  defp score_card("Q", _), do: 12
  defp score_card("J", part: 1), do: 11
  defp score_card("J", part: 2), do: 1
  defp score_card("T", _), do: 10
  defp score_card(card, _), do: String.to_integer(card)
end

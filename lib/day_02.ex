defmodule Advent2023.Day02 do
  @moduledoc false

  @input Advent2023.Helpers.get_input_for_day(2)
  @limits %{red: 12, green: 13, blue: 14}

  def part_1(input \\ @input) do
    input
    |> parse_input()
    |> Map.filter(&game_possible?/1)
    |> Map.keys()
    |> Enum.sum()
  end

  def part_2(input \\ @input) do
    input
    |> parse_input()
    |> Enum.map(fn game ->
      game
      |> minimum_necessary_set()
      |> Map.values()
      |> Enum.product()
    end)
    |> Enum.sum()
  end

  defp parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Map.new(&parse_line/1)
  end

  defp parse_line(line) do
    [game_str, sets_str] = String.split(line, ": ")
    [_, game_number_str] = String.split(game_str, " ")
    set_maps = sets_str |> String.split("; ") |> Enum.map(&parse_set/1)

    {String.to_integer(game_number_str), set_maps}
  end

  defp parse_set(set) do
    set
    |> String.split(", ")
    |> Map.new(fn color_count ->
      [count, color] = String.split(color_count, " ")
      {String.to_existing_atom(color), String.to_integer(count)}
    end)
  end

  defp game_possible?({_game_number, sets}) do
    Enum.all?(sets, &Enum.all?(&1, fn {color, count} -> count <= @limits[color] end))
  end

  defp minimum_necessary_set({_game_number, sets}) do
    Enum.reduce(sets, %{}, &Map.merge(&1, &2, fn _key, v1, v2 -> max(v1, v2) end))
  end
end

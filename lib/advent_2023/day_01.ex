defmodule Advent2023.Day01 do
  @moduledoc false

  @input Advent2023.get_input_for_day(1)
  @numbers ~w(1 2 3 4 5 6 7 8 9 0)

  def part_1 do
    @input
    |> parse_input()
    |> Enum.map(&process_line(&1, :part_1))
    |> Enum.sum()
  end

  def part_2 do
    @input
    |> parse_input()
    |> Enum.map(&process_line(&1, :part_2))
    |> Enum.sum()
  end

  defp parse_input(lines) do
    lines
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
  end

  defp process_line(line_list, first \\ nil, last \\ nil, part)

  defp process_line([], first, last, _), do: String.to_integer(first <> last)

  defp process_line(["o", "n", "e" | _] = [_h | t], first, _last, :part_2),
    do: process_line(t, first || "1", "1", :part_2)

  defp process_line(["t", "w", "o" | _] = [_h | t], first, _last, :part_2),
    do: process_line(t, first || "2", "2", :part_2)

  defp process_line(["t", "h", "r", "e", "e" | _] = [_h | t], first, _last, :part_2),
    do: process_line(t, first || "3", "3", :part_2)

  defp process_line(["f", "o", "u", "r" | _] = [_h | t], first, _last, :part_2),
    do: process_line(t, first || "4", "4", :part_2)

  defp process_line(["f", "i", "v", "e" | _] = [_h | t], first, _last, :part_2),
    do: process_line(t, first || "5", "5", :part_2)

  defp process_line(["s", "i", "x" | _] = [_h | t], first, _last, :part_2),
    do: process_line(t, first || "6", "6", :part_2)

  defp process_line(["s", "e", "v", "e", "n" | _] = [_h | t], first, _last, :part_2),
    do: process_line(t, first || "7", "7", :part_2)

  defp process_line(["e", "i", "g", "h", "t" | _] = [_h | t], first, _last, :part_2),
    do: process_line(t, first || "8", "8", :part_2)

  defp process_line(["n", "i", "n", "e" | _] = [_h | t], first, _last, :part_2),
    do: process_line(t, first || "9", "9", :part_2)

  defp process_line([h | t], first, _last, part) when h in @numbers, do: process_line(t, first || h, h, part)

  defp process_line([_h | t], first, last, part), do: process_line(t, first, last, part)
end

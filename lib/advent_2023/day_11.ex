defmodule Advent2023.Day11 do
  @moduledoc false

  @input Advent2023.get_input_for_day(11)

  def part_1(input \\ @input), do: run(input, 2)

  def part_2(input \\ @input), do: run(input, 1_000_000)

  def run(input, expansion_size) do
    state = parse_input(input)
    max_idx = length(state.galaxies) - 1

    # No duplicates!
    pairs =
      Enum.flat_map(0..(max_idx - 1), fn n ->
        [h | t] = Enum.drop(state.galaxies, n)
        Enum.map(t, fn coord -> {h, coord} end)
      end)

    pairs
    |> Enum.map(fn {{x1, y1}, {x2, y2}} ->
      # Distance between two points
      dx = x2 - x1
      dy = y2 - y1

      # Count how many empty rows or columns are in between
      expanded_count =
        Enum.count(state.empty_cols, fn col_idx ->
          col_idx in x1..x2
        end) +
          Enum.count(state.empty_rows, fn row_idx ->
            row_idx in y1..y2
          end)

      # Manhattan distance with the empty rows/columns expanded
      abs(dx) + abs(dy) + expanded_count * (expansion_size - 1)
    end)
    |> Enum.sum()
  end

  defp parse_input(input) do
    input
    |> String.graphemes()
    |> init_map()
    |> init_state()
  end

  defp init_map(input_list, x \\ 0, y \\ 0, map \\ %{})
  defp init_map([], _, _, map), do: map
  defp init_map(["\n" | t], _, y, map), do: init_map(t, 0, y + 1, map)
  defp init_map([h | t], x, y, map), do: init_map(t, x + 1, y, Map.put(map, {x, y}, h))

  defp init_state(map) do
    %{
      galaxies: Enum.reduce(map, [], fn {coord, symbol}, acc -> if symbol == "#", do: [coord | acc], else: acc end),
      empty_rows: empty_indexes(map, :y),
      empty_cols: empty_indexes(map, :x)
    }
  end

  defp empty_indexes(map, direction) do
    get_coord_fn =
      case direction do
        :x -> &elem(&1, 0)
        :y -> &elem(&1, 1)
      end

    map
    # Coords have to be sorted for the following chunk to work
    |> Enum.sort_by(fn {coord, _symbol} -> get_coord_fn.(coord) end)
    # Group coords, one list per row/column
    |> Enum.chunk_by(fn {coord, _symbol} -> get_coord_fn.(coord) end)
    # Filter only empty rows/columns
    |> Enum.filter(&Enum.all?(&1, fn {_coord, symbol} -> symbol == "." end))
    # Get the index of each row/column (y value for rows, x value for columns)
    |> Enum.map(fn [{coord, _} | _] -> get_coord_fn.(coord) end)
  end
end

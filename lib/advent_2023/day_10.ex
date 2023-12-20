defmodule Advent2023.Day10 do
  @moduledoc false

  @input Advent2023.get_input_for_day(10)
  @cardinal_directions ~w(north east south west)a
  @unit_vectors [{0, -1}, {1, 0}, {0, 1}, {-1, 0}]
  @vector_map Map.new(Enum.zip(@cardinal_directions, @unit_vectors))
  @pipe_directions %{
    "-" => [:east, :west],
    "|" => [:north, :south],
    "7" => [:south, :west],
    "J" => [:north, :west],
    "L" => [:north, :east],
    "F" => [:east, :south],
    "S" => :unknown
  }
  @pipes Map.keys(@pipe_directions)

  def part_1(input \\ @input) do
    input
    |> parse_input()
    |> replace_s_pipe()
    |> split_animal()
    |> trace_loop()
    |> Map.fetch!(:steps)
  end

  def part_2(input \\ @input) do
    %{animal_a: %{seen: seen_a}, animal_b: %{seen: seen_b}, map: map} =
      input
      |> parse_input()
      |> replace_s_pipe()
      |> split_animal()
      |> trace_loop()

    loop = MapSet.union(MapSet.new(seen_a), MapSet.new(seen_b))

    loop
    |> Enum.sort()
    |> Enum.chunk_by(fn {x, _y} -> x end)
    |> Enum.map(fn column ->
      column
      |> Enum.map(fn coord -> {coord, map[coord]} end)
      |> Enum.reject(fn {_, symbol} -> symbol == "|" end)
      |> area_in_col()
    end)
    |> Enum.sum()
  end

  defp parse_input(input) do
    input
    |> String.graphemes()
    |> do_parse(0, 0, %{})
  end

  defp do_parse([], _, _, acc), do: acc
  defp do_parse(["\n" | t], _x, y, acc), do: do_parse(t, 0, y + 1, acc)

  defp do_parse([h | t], x, y, acc) do
    new_acc = if h in @pipes, do: Map.put(acc, {x, y}, h), else: acc
    do_parse(t, x + 1, y, new_acc)
  end

  defp replace_s_pipe(map) do
    {{x, y} = s_coord, "S"} = Enum.find(map, fn {_coord, pipe} -> pipe == "S" end)

    s_directions =
      @cardinal_directions
      |> Enum.zip(@unit_vectors)
      |> Enum.filter(fn {direction, {dx, dy}} ->
        case map[{x + dx, y + dy}] do
          nil -> false
          pipe -> opposite(direction) in @pipe_directions[pipe]
        end
      end)
      |> Enum.map(fn {direction, _coord} -> direction end)

    {pipe, _} = Enum.find(@pipe_directions, fn {_, directions} -> directions == s_directions end)

    %{map: Map.put(map, s_coord, pipe), animal_start: s_coord}
  end

  defp opposite(:north), do: :south
  defp opposite(:south), do: :north
  defp opposite(:east), do: :west
  defp opposite(:west), do: :east

  defp split_animal(state) do
    pipe = Map.fetch!(state.map, state.animal_start)

    [coord_a, coord_b] =
      Enum.map(@pipe_directions[pipe], fn direction ->
        {dx, dy} = @vector_map[direction]
        {x, y} = state.animal_start
        {x + dx, y + dy}
      end)

    state
    |> Map.put(:animal_a, %{current: coord_a, seen: [coord_a, state.animal_start]})
    |> Map.put(:animal_b, %{current: coord_b, seen: [coord_b, state.animal_start]})
    |> Map.put(:steps, 1)
  end

  defp trace_loop(%{animal_a: %{current: c}, animal_b: %{current: c}} = state), do: state

  defp trace_loop(state) do
    state
    |> Map.put(:animal_a, step_forward(state, :animal_a))
    |> Map.put(:animal_b, step_forward(state, :animal_b))
    |> Map.update!(:steps, &(&1 + 1))
    |> trace_loop()
  end

  defp step_forward(state, key) do
    %{current: {x, y} = coord, seen: [_, prev | _]} = state[key]
    pipe = Map.fetch!(state.map, coord)

    [next_coord] =
      @pipe_directions[pipe]
      |> Enum.map(fn direction ->
        {dx, dy} = @vector_map[direction]
        {x + dx, y + dy}
      end)
      |> Enum.reject(fn coord -> coord == prev end)

    state[key]
    |> Map.put(:current, next_coord)
    |> Map.update!(:seen, &[next_coord | &1])
  end

  defp area_in_col(coords, inside? \\ false, prev \\ {nil, nil}, total \\ 0)

  defp area_in_col([], _, _, total), do: total

  defp area_in_col([{{_, y}, symbol} | next], inside?, {prev_y, _prev_symbol}, total) when symbol in ~w(F 7) do
    new_total = if inside?, do: y - prev_y - 1 + total, else: total
    area_in_col(next, inside?, {y, symbol}, new_total)
  end

  defp area_in_col([{{_, y}, "-"} | next], inside?, {prev_y, _prev_symbol}, total) do
    new_total = if inside?, do: y - prev_y - 1 + total, else: total
    area_in_col(next, !inside?, {y, "-"}, new_total)
  end

  defp area_in_col([{{_, y}, "L"} | next], inside?, {_prev_y, prev_symbol}, total) do
    now_inside? = if prev_symbol == "F", do: inside?, else: !inside?
    area_in_col(next, now_inside?, {y, "L"}, total)
  end

  defp area_in_col([{{_, y}, "J"} | next], inside?, {_prev_y, prev_symbol}, total) do
    now_inside? = if prev_symbol == "7", do: inside?, else: !inside?
    area_in_col(next, now_inside?, {y, "J"}, total)
  end
end

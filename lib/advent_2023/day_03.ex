defmodule Advent2023.Day03 do
  @moduledoc false

  @input Advent2023.get_input_for_day(3)
  @digits ~w(1 2 3 4 5 6 7 8 9 0)
  @empty_buffer %{content: "", neighbors: MapSet.new()}

  def part_1(input \\ @input) do
    input
    |> parse_grid()
    |> valid_part_numbers()
    |> Enum.sum()
  end

  def part_2(input \\ @input) do
    input
    |> parse_grid()
    |> gear_ratios()
    |> Enum.sum()
  end

  defp parse_grid(input) do
    init_state = %{
      todo: String.graphemes(input),
      x: 0,
      y: 0,
      buffer: @empty_buffer,
      numbers: [],
      symbols: %{}
    }

    parse(init_state)
  end

  defp parse(%{todo: []} = state) do
    clear_buffer(state)
  end

  defp parse(%{todo: [h | t]} = state) when h in @digits do
    state
    |> add_to_buffer(h)
    |> increment(:x)
    |> Map.put(:todo, t)
    |> parse()
  end

  defp parse(%{todo: ["\n" | t]} = state) do
    state
    |> Map.put(:x, 0)
    |> increment(:y)
    |> clear_buffer()
    |> Map.put(:todo, t)
    |> parse()
  end

  defp parse(%{todo: ["." | t]} = state) do
    state
    |> increment(:x)
    |> clear_buffer()
    |> Map.put(:todo, t)
    |> parse()
  end

  defp parse(%{todo: [h | t]} = state) do
    state
    |> add_symbol(h)
    |> increment(:x)
    |> clear_buffer()
    |> Map.put(:todo, t)
    |> parse()
  end

  defp clear_buffer(state) do
    %{buffer: buffer, numbers: numbers} = state
    numbers = if buffer == @empty_buffer, do: numbers, else: [buffer | numbers]

    %{state | buffer: @empty_buffer, numbers: numbers}
  end

  defp add_to_buffer(state, content) do
    new_buffer =
      state.buffer
      |> Map.update!(:content, &(&1 <> content))
      |> Map.update!(:neighbors, &add_neighbors(&1, {state.x, state.y}))

    %{state | buffer: new_buffer}
  end

  defp add_neighbors(mapset, coord) do
    coord
    |> neighbors()
    |> MapSet.new()
    |> MapSet.union(mapset)
  end

  defp neighbors({x, y}) do
    # It's OK to include {x, y} because that coord can't contain a symbol
    for i <- [x - 1, x, x + 1],
        j <- [y - 1, y, y + 1] do
      {i, j}
    end
  end

  defp increment(state, key), do: Map.update!(state, key, &(&1 + 1))

  defp add_symbol(state, h), do: Map.update!(state, :symbols, &Map.put(&1, {state.x, state.y}, h))

  defp valid_part_numbers(state) do
    state.numbers
    |> Enum.filter(fn number -> Enum.any?(number.neighbors, &Map.has_key?(state.symbols, &1)) end)
    |> Enum.map(fn number -> String.to_integer(number.content) end)
  end

  defp gear_ratios(state) do
    Enum.map(state.symbols, fn
      {{x, y}, "*"} -> calculate_gear_ratio(x, y, state.numbers)
      _ -> 0
    end)
  end

  defp calculate_gear_ratio(x, y, numbers) do
    adjacent_numbers = Enum.filter(numbers, &MapSet.member?(&1.neighbors, {x, y}))

    if length(adjacent_numbers) == 2 do
      adjacent_numbers
      |> Enum.map(&String.to_integer(&1.content))
      |> Enum.product()
    else
      0
    end
  end
end

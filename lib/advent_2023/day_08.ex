defmodule Advent2023.Day08 do
  @moduledoc false

  @input Advent2023.get_input_for_day(8)

  def part_1(input \\ @input) do
    input
    |> parse_input()
    |> Map.put(:current_node, "AAA")
    |> Map.put(:part, 1)
    |> run()
  end

  def part_2(input \\ @input) do
    state = parse_input(input)

    state.map
    |> Map.keys()
    |> Enum.filter(&String.ends_with?(&1, "A"))
    |> Enum.map(fn ghost_start ->
      state
      |> Map.put(:current_node, ghost_start)
      |> Map.put(:part, 2)
      |> run()
    end)
    |> lcm()
  end

  defp parse_input(input) do
    [instructions_str, map_str] = String.split(input, "\n\n")

    instructions =
      instructions_str
      |> String.graphemes()
      |> Enum.map(&String.to_atom/1)

    map =
      map_str
      |> String.split("\n", trim: true)
      |> Map.new(fn line ->
        [start, left, right] = String.split(line, [" = (", ", ", ")"], trim: true)
        {start, %{L: left, R: right}}
      end)

    %{instructions: instructions, map: map, steps: 0}
  end

  defp run(state) do
    cond do
      state.part == 1 and state.current_node == "ZZZ" ->
        state.steps

      state.part == 2 and String.ends_with?(state.current_node, "Z") ->
        state.steps

      :otherwise ->
        state.instructions
        |> Enum.reduce(state, fn instruction, acc ->
          acc
          |> Map.update!(:current_node, &state.map[&1][instruction])
          |> Map.update!(:steps, &(&1 + 1))
        end)
        |> run()
    end
  end

  defp lcm(nums), do: Enum.reduce(nums, 1, &div(&1 * &2, Integer.gcd(&1, &2)))
end

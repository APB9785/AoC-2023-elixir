defmodule Advent2023.Day09 do
  @moduledoc false

  @input Advent2023.get_input_for_day(9)

  def part_1(input \\ @input) do
    input
    |> parse_input()
    |> Enum.map(&next_in_seq/1)
    |> Enum.sum()
  end

  def part_2(input \\ @input) do
    input
    |> parse_input()
    |> Enum.map(&prev_in_seq/1)
    |> Enum.sum()
  end

  defp parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split(" ")
      |> Enum.map(&String.to_integer/1)
    end)
  end

  defp next_in_seq(nums) do
    cond do
      length(Enum.dedup(nums)) <= 1 -> hd(nums)
      :otherwise -> List.last(nums) + (nums |> extrapolate() |> next_in_seq())
    end
  end

  defp prev_in_seq(nums) do
    cond do
      length(Enum.dedup(nums)) <= 1 -> hd(nums)
      :otherwise -> List.first(nums) - (nums |> extrapolate() |> prev_in_seq())
    end
  end

  defp extrapolate(nums) do
    nums
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [a, b] -> b - a end)
  end
end

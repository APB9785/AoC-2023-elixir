defmodule Advent2023.Day06 do
  @moduledoc false

  @input Advent2023.get_input_for_day(6)

  def part_1(input \\ @input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split(" ", trim: true)
      |> tl()
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.zip_with(fn [time, distance] -> %{time: time, distance: distance} end)
    |> Enum.map(&ways_to_win/1)
    |> Enum.product()
  end

  def part_2(input \\ @input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split(" ", trim: true)
      |> tl()
      |> Enum.join()
      |> String.to_integer()
    end)
    |> ways_to_win()
  end

  defp ways_to_win([time, distance]), do: ways_to_win(%{time: time, distance: distance})

  defp ways_to_win(race) do
    Enum.count(1..race.time, fn held_seconds ->
      traveled = held_seconds * (race.time - held_seconds)
      traveled > race.distance
    end)
  end
end

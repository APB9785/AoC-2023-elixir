defmodule Advent2023.Day05 do
  @moduledoc false

  @input Advent2023.get_input_for_day(5)
  @categories ~w(soil fertilizer water light temperature humidity location)a

  def part_1(input \\ @input) do
    {seeds, maps} = parse_input(input)

    seeds
    |> Enum.map(&location_for_seed(&1, maps))
    |> Enum.min()
  end

  def part_2(input \\ @input) do
    {seeds, maps} = parse_input(input)

    possible_location_values = Stream.iterate(1, &(&1 + 1))

    seed_ranges =
      seeds
      |> Enum.chunk_every(2)
      |> Enum.map(fn [start, range] -> start..(start + range - 1) end)

    possible_location_values
    |> Stream.filter(fn location ->
      seed = seed_for_location(location, maps)
      Enum.any?(seed_ranges, &(&1.first <= seed and seed <= &1.last))
    end)
    |> Enum.take(1)
    |> hd()
  end

  defp parse_input(input) do
    ["seeds: " <> seeds | maps] = String.split(input, "\n\n")

    parsed_seeds = seeds |> String.split(" ") |> Enum.map(&String.to_integer/1)

    parsed_maps =
      Map.new(maps, fn map ->
        [header | rules] = String.split(map, "\n", trim: true)
        [_, "to", category, "map:"] = String.split(header, ["-", " "])

        parsed_rules =
          Enum.map(rules, fn rule ->
            [destination_range_start, source_range_start, range_length] =
              rule
              |> String.split(" ", trim: true)
              |> Enum.map(&String.to_integer/1)

            %{
              destination_range_start: destination_range_start,
              source_range_start: source_range_start,
              range_length: range_length
            }
          end)

        {String.to_existing_atom(category), parsed_rules}
      end)

    {parsed_seeds, parsed_maps}
  end

  defp location_for_seed(seed, maps) do
    Enum.reduce(@categories, seed, fn category, acc -> convert(acc, category, maps) end)
  end

  defp seed_for_location(location, maps) do
    @categories
    |> Enum.reverse()
    |> Enum.reduce(location, fn category, acc -> revert(acc, category, maps) end)
  end

  defp convert(source, destination_category, maps) do
    rules = Map.fetch!(maps, destination_category)

    case Enum.find(rules, &rule_applicable?(&1, source: source)) do
      nil ->
        source

      applicable_rule ->
        offset = source - applicable_rule.source_range_start
        applicable_rule.destination_range_start + offset
    end
  end

  defp rule_applicable?(rule, source: source) do
    rule.source_range_start <= source and source <= rule.source_range_start + rule.range_length - 1
  end

  defp rule_applicable?(rule, destination: destination) do
    rule.destination_range_start <= destination and destination <= rule.destination_range_start + rule.range_length - 1
  end

  defp revert(destination, destination_category, maps) do
    rules = Map.fetch!(maps, destination_category)

    case Enum.find(rules, &rule_applicable?(&1, destination: destination)) do
      nil ->
        destination

      applicable_rule ->
        offset = destination - applicable_rule.destination_range_start
        applicable_rule.source_range_start + offset
    end
  end
end

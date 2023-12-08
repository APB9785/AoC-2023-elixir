defmodule Advent2023.Day07Test do
  use ExUnit.Case

  @example_input """
  32T3K 765
  T55J5 684
  KK677 28
  KTJJT 220
  QQQJA 483
  """

  test "Part 1" do
    assert Advent2023.Day07.part_1(@example_input) == 6440
  end

  test "Part 2" do
    assert Advent2023.Day07.part_2(@example_input) == 5905
  end
end

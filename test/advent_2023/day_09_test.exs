defmodule Advent2023.Day09Test do
  use ExUnit.Case

  @example_input """
  0 3 6 9 12 15
  1 3 6 10 15 21
  10 13 16 21 30 45
  """

  test "Part 1" do
    assert Advent2023.Day09.part_1(@example_input) == 114
  end

  test "Part 2" do
    assert Advent2023.Day09.part_2(@example_input) == 2
  end
end

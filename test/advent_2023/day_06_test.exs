defmodule Advent2023.Day06Test do
  use ExUnit.Case

  @example_input """
  Time:      7  15   30
  Distance:  9  40  200
  """

  test "Part 1" do
    assert Advent2023.Day06.part_1(@example_input) == 288
  end

  test "Part 2" do
    assert Advent2023.Day06.part_2(@example_input) == 71503
  end
end

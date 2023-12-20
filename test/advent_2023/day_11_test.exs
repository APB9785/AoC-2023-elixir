defmodule Advent2023.Day11Test do
  use ExUnit.Case

  @example_input """
  ...#......
  .......#..
  #.........
  ..........
  ......#...
  .#........
  .........#
  ..........
  .......#..
  #...#.....
  """

  test "Part 1" do
    assert Advent2023.Day11.part_1(@example_input) == 374
  end

  test "Part 2" do
    assert Advent2023.Day11.run(@example_input, 10) == 1030
    assert Advent2023.Day11.run(@example_input, 100) == 8410
  end
end

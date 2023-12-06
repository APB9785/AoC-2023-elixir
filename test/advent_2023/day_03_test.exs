defmodule Advent2023.Day03Test do
  use ExUnit.Case

  @example_input """
  467..114..
  ...*......
  ..35..633.
  ......#...
  617*......
  .....+.58.
  ..592.....
  ......755.
  ...$.*....
  .664.598..
  """

  test "Part 1" do
    assert Advent2023.Day03.part_1(@example_input) == 4361
  end

  test "Part 2" do
    assert Advent2023.Day03.part_2(@example_input) == 467_835
  end
end

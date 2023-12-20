defmodule Advent2023.Day10Test do
  use ExUnit.Case

  @simple_example """
  .....
  .S-7.
  .|.|.
  .L-J.
  .....
  """

  @complex_example """
  ..F7.
  .FJ|.
  SJ.L7
  |F--J
  LJ...
  """

  test "Part 1" do
    assert Advent2023.Day10.part_1(@simple_example) == 4
    assert Advent2023.Day10.part_1(@complex_example) == 8
  end

  @simple_example_2 """
  ...........
  .S-------7.
  .|F-----7|.
  .||.....||.
  .||.....||.
  .|L-7.F-J|.
  .|..|.|..|.
  .L--J.L--J.
  ...........
  """

  @complex_example_2 """
  .F----7F7F7F7F-7....
  .|F--7||||||||FJ....
  .||.FJ||||||||L7....
  FJL7L7LJLJ||LJ.L-7..
  L--J.L7...LJS7F-7L7.
  ....F-J..F7FJ|L7L7L7
  ....L7.F7||L7|.L7L7|
  .....|FJLJ|FJ|F7|.LJ
  ....FJL-7.||.||||...
  ....L---J.LJ.LJLJ...
  """

  @complex_example_3 """
  FF7FSF7F7F7F7F7F---7
  L|LJ||||||||||||F--J
  FL-7LJLJ||||||LJL-77
  F--JF--7||LJLJ7F7FJ-
  L---JF-JLJ.||-FJLJJ7
  |F|F-JF---7F7-L7L|7|
  |FFJF7L7F-JF7|JL---7
  7-L-JL7||F7|L7F-7F7|
  L.L7LFJ|||||FJL7||LJ
  L7JLJL-JLJLJL--JLJ.L
  """

  test "Part 2" do
    assert Advent2023.Day10.part_2(@simple_example_2) == 4
    assert Advent2023.Day10.part_2(@complex_example_2) == 8
    assert Advent2023.Day10.part_2(@complex_example_3) == 10
  end
end

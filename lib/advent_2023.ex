defmodule Advent2023 do
  @moduledoc """
  Helper functions
  """

  def get_input_for_day(day) do
    path = Application.app_dir(:advent_2023, "priv/day_#{day}_input.txt")
    File.read!(path)
  end
end

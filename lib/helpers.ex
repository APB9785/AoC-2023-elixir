defmodule Advent2023.Helpers do
  @moduledoc false

  def get_input_for_day(day) do
    path = Application.app_dir(:advent_2023, "priv/day_#{day}_input.txt")
    File.read!(path)
  end
end

defmodule HumanTimeTest do
  use ExUnit.Case

  test "duration in milliseconds" do
    assert HumanTime.human(754000) == "12 minutes from now"
  end

  test "duration in milliseconds (negative)" do
    assert HumanTime.human(-754000) == "12 minutes ago"
  end

  test "future DateTime" do
    future_time = DateTime.utc_now() |> DateTime.add(5, :second)
    assert HumanTime.human(future_time) == "5 seconds from now"
  end

  test "past DateTime" do
    past_time = DateTime.utc_now() |> DateTime.add(-5, :second)
    assert HumanTime.human(past_time) == "5 seconds ago"
  end
end

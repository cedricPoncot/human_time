defmodule HumanTimeTest do
  use ExUnit.Case

  # Millisecond input
  test "duration in milliseconds" do
    assert HumanTime.human(754000) == "12 minutes from now"
  end

  test "duration in milliseconds (negative)" do
    assert HumanTime.human(-754000) == "12 minutes ago"
  end

  # DateTime input
  test "future DateTime" do
    future_time = DateTime.utc_now() |> DateTime.add(5, :second)
    assert HumanTime.human(future_time) == "5 seconds from now"
  end

  test "past DateTime" do
    past_time = DateTime.utc_now() |> DateTime.add(-5, :second)
    assert HumanTime.human(past_time) == "5 seconds ago"
  end

  test "localized output (French)" do
    future_time = DateTime.utc_now() |> DateTime.add(120, :second)
    assert HumanTime.human(future_time, locale: "fr") == "dans 2 minutes"

    past_time = DateTime.utc_now() |> DateTime.add(-3600, :second)
    assert HumanTime.human(past_time, locale: "fr") == "il y a 1 heure"
  end
end

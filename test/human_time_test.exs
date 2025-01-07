defmodule HumanTimeTest do
  use ExUnit.Case

  test "duration in milliseconds" do
    assert HumanTime.human(754_000) == "12 minutes from now"
  end

  test "duration in milliseconds (negative)" do
    assert HumanTime.human(-754_000) == "12 minutes ago"
  end

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

  test "localized output (Spanish)" do
    future_time = DateTime.utc_now() |> DateTime.add(120, :second)
    assert HumanTime.human(future_time, locale: "es") == "en 2 minutos"

    past_time = DateTime.utc_now() |> DateTime.add(-3600, :second)
    assert HumanTime.human(past_time, locale: "es") == "hace 1 hora"
  end

  test "localized output (Chinese)" do
    future_time = DateTime.utc_now() |> DateTime.add(120, :second)
    assert HumanTime.human(future_time, locale: "zh") == "2分钟后"

    past_time = DateTime.utc_now() |> DateTime.add(-3600, :second)
    assert HumanTime.human(past_time, locale: "zh") == "1小时前"
  end
end

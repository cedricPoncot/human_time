defmodule HumanTime do
  @moduledoc """
  A module to convert time intervals into human-readable strings.
  """

  @spec human(integer() | DateTime.t()) :: <<_::32, _::_*8>>
  @doc """
  Converts a duration (in milliseconds or DateTime) into a human-readable string.

  ## Examples

      iex> HumanTime.human(754000)
      "12 minutes from now"

      iex> HumanTime.human(-754000)
      "12 minutes ago"

      iex> HumanTime.human(DateTime.utc_now() |> DateTime.add(5, :second))
      "5 seconds from now"

      iex> HumanTime.human(DateTime.utc_now() |> DateTime.add(-5, :second))
      "5 seconds ago"

  """
  def human(input) when is_integer(input) do
    seconds = div(input, 1000)
    human_diff(seconds)
  end

  def human(%DateTime{} = date) do
    now = DateTime.utc_now() |> DateTime.to_unix()
    diff = DateTime.to_unix(date) - now
    human_diff(diff)
  end

  defp human_diff(seconds) when seconds < 0 do
    time_phrase(-seconds) <> " ago"
  end

  defp human_diff(seconds) when seconds >= 0 do
    time_phrase(seconds) <> " from now"
  end

  defp time_phrase(seconds) when seconds < 60 do
    "#{seconds} second#{pluralize(seconds)}"
  end

  defp time_phrase(seconds) when seconds < 3600 do
    minutes = div(seconds, 60)
    "#{minutes} minute#{pluralize(minutes)}"
  end

  defp time_phrase(seconds) when seconds < 86_400 do
    hours = div(seconds, 3600)
    "#{hours} hour#{pluralize(hours)}"
  end

  defp time_phrase(seconds) do
    days = div(seconds, 86_400)
    "#{days} day#{pluralize(days)}"
  end

  defp pluralize(1), do: ""
  defp pluralize(_), do: "s"
end

defmodule HumanTime do
  @moduledoc """
  A module to convert time intervals into human-readable strings with support for localization.
  """

  @translations %{
    "en" => %{
      "ago" => "{time} ago",
      "from_now" => "{time} from now",
      "second" => " second",
      "minute" => " minute",
      "hour" => " hour",
      "day" => " day"
    },
    "fr" => %{
      "ago" => "il y a {time}",
      "from_now" => "dans {time}",
      "second" => " seconde",
      "minute" => " minute",
      "hour" => " heure",
      "day" => " jour"
    },
    "es" => %{
      "ago" => "hace {time}",
      "from_now" => "en {time}",
      "second" => " segundo",
      "minute" => " minuto",
      "hour" => " hora",
      "day" => " día"
    },
    "zh" => %{
      "ago" => "{time}前",
      "from_now" => "{time}后",
      "second" => "秒",
      "minute" => "分钟",
      "hour" => "小时",
      "day" => "天"
    },
    "ru" => %{
      "ago" => "{time} назад",
      "from_now" => "через {time}",
      "second" => " секунда",
      "minute" => " минута",
      "hour" => " час",
      "day" => " день"
    }
  }

  @default_locale "en"

  @doc """
  Converts a duration (in milliseconds or DateTime) into a human-readable string with optional localization.

  ## Examples

      iex> HumanTime.human(754000)
      "12 minutes from now"

      iex> HumanTime.human(-754000)
      "12 minutes ago"

      iex> HumanTime.human(DateTime.utc_now() |> DateTime.add(5, :second))
      "5 seconds from now"

      iex> HumanTime.human(DateTime.utc_now() |> DateTime.add(-5, :second))
      "5 seconds ago"

      iex> HumanTime.human(-754000, locale: "fr")
      "il y a 12 minutes"
  """
  @spec human(integer() | DateTime.t(), keyword()) :: String.t()
  def human(input, opts \\ []) do
    locale = Keyword.get(opts, :locale, @default_locale)
    translations = Map.get(@translations, locale, @translations[@default_locale])

    case input do
      ms when is_integer(ms) ->
        seconds = div(ms, 1000)
        human_diff(seconds, translations, locale)

      %DateTime{} = datetime ->
        now = DateTime.utc_now() |> DateTime.to_unix()
        diff = DateTime.to_unix(datetime) - now
        human_diff(diff, translations, locale)
    end
  end

  defp human_diff(seconds, translations, locale) when seconds < 0 do
    time = time_phrase(-seconds, translations, locale)
    String.replace(translations["ago"], "{time}", time)
  end

  defp human_diff(seconds, translations, locale) when seconds >= 0 do
    time = time_phrase(seconds, translations, locale)
    String.replace(translations["from_now"], "{time}", time)
  end

  defp time_phrase(seconds, translations, locale) when seconds < 60 do
    count = seconds
    "#{count}#{translations["second"]}#{pluralize(count, locale)}"
  end

  defp time_phrase(seconds, translations, locale) when seconds < 3600 do
    count = div(seconds, 60)
    "#{count}#{translations["minute"]}#{pluralize(count, locale)}"
  end

  defp time_phrase(seconds, translations, locale) when seconds < 86_400 do
    count = div(seconds, 3600)
    "#{count}#{translations["hour"]}#{pluralize(count, locale)}"
  end

  defp time_phrase(seconds, translations, locale) do
    count = div(seconds, 86_400)
    "#{count}#{translations["day"]}#{pluralize(count, locale)}"
  end

  defp pluralize(1, _locale), do: ""
  defp pluralize(_, "zh"), do: ""  # No pluralization in Chinese
  defp pluralize(count, "ru") do
    cond do
      rem(count, 10) == 1 and rem(count, 100) != 11 -> ""       # Singular
      rem(count, 10) in 2..4 and rem(count, 100) not in 12..14 -> "ы"  # Plural for 2–4
      true -> ""  # Default for other cases, e.g., 5–20
    end
  end

  defp pluralize(_, _locale), do: "s"  # Default to English pluralization

end

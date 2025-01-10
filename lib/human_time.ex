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
      "day" => " day",
      "month" => " month",
      "year" => " year"
    },
    "fr" => %{
      "ago" => "il y a {time}",
      "from_now" => "dans {time}",
      "second" => " seconde",
      "minute" => " minute",
      "hour" => " heure",
      "day" => " jour",
      "month" => " mois",
      "year" => " an"
    },
    "es" => %{
      "ago" => "hace {time}",
      "from_now" => "en {time}",
      "second" => " segundo",
      "minute" => " minuto",
      "hour" => " hora",
      "day" => " día",
      "month" => " mes",
      "year" => " año"
    },
    "zh" => %{
      "ago" => "{time}前",
      "from_now" => "{time}后",
      "second" => "秒",
      "minute" => "分钟",
      "hour" => "小时",
      "day" => "天",
      "month" => "月",
      "year" => "年"
    },
    "pt" => %{
      "ago" => "há {time}",
      "from_now" => "em {time}",
      "second" => " segundo",
      "minute" => " minuto",
      "hour" => " hora",
      "day" => " dia"
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
    verbose = Keyword.get(opts, :verbose, 1)
    translations = Map.get(@translations, locale, @translations[@default_locale])

    case input do
      ms when is_integer(ms) ->
        seconds = div(ms, 1000)
        human_diff(seconds, translations, locale, verbose)

      %DateTime{} = datetime ->
        now = DateTime.utc_now()
        seconds = DateTime.diff(datetime, now)
        human_diff(seconds, translations, locale, verbose)
    end
  end

  defp human_diff(seconds, translations, locale, verbose) do
    # Determine if the time is in the past or future
    is_future = seconds >= 0
    seconds = abs(seconds)

    # Calculate the time difference in various units
    years = div(seconds, 31_536_000)
    seconds = rem(seconds, 31_536_000)
    months = div(seconds, 2_592_000)
    seconds = rem(seconds, 2_592_000)
    days = div(seconds, 86_400)
    seconds = rem(seconds, 86_400)
    hours = div(seconds, 3_600)
    seconds = rem(seconds, 3_600)
    minutes = div(seconds, 60)
    seconds = rem(seconds, 60)

    time_units = [
      {"year", years},
      {"month", months},
      {"day", days},
      {"hour", hours},
      {"minute", minutes},
      {"second", seconds}
    ]

    time_phrase(time_units, translations, verbose, is_future, locale)
  end

  defp time_phrase(time_units, translations, verbose, is_future, locale) do
    time_str = time_units
    |> Enum.filter(fn {_, value} -> value > 0 end)
    |> Enum.take(verbose)
    |> Enum.map(fn {unit, value} ->
      unit_translation = Map.get(translations, unit)
      "#{value}#{unit_translation}#{pluralize(value, locale)}"
    end)
    |> Enum.join(", ")

    if time_str == "" do
      time_str
    else
      if is_future do
        "#{Map.get(translations, "from_now") |> String.replace("{time}", time_str)}"
      else
        "#{Map.get(translations, "ago") |> String.replace("{time}", time_str)}"
      end
    end
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

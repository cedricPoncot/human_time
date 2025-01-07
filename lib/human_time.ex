defmodule HumanTime do
  @moduledoc """
  A module to convert time intervals into human-readable strings, with localization support.
  """

  @locales %{
    "en" => %{
      "ago" => "ago",
      "from_now" => "from now",
      "second" => "second",
      "seconds" => "seconds",
      "minute" => "minute",
      "minutes" => "minutes",
      "hour" => "hour",
      "hours" => "hours",
      "day" => "day",
      "days" => "days"
    },
    "fr" => %{
      "ago" => "il y a",
      "from_now" => "dans",
      "second" => "seconde",
      "seconds" => "secondes",
      "minute" => "minute",
      "minutes" => "minutes",
      "hour" => "heure",
      "hours" => "heures",
      "day" => "jour",
      "days" => "jours"
    },
    "es" => %{
      "ago" => "hace",
      "from_now" => "en",
      "second" => "segundo",
      "seconds" => "segundos",
      "minute" => "minuto",
      "minutes" => "minutos",
      "hour" => "hora",
      "hours" => "horas",
      "day" => "día",
      "days" => "días"
    },
    "zh" => %{
      "ago" => "前",
      "from_now" => "后",
      "second" => "秒",
      "seconds" => "秒",
      "minute" => "分钟",
      "minutes" => "分钟",
      "hour" => "小时",
      "hours" => "小时",
      "day" => "天",
      "days" => "天"
    },
    "ru" => %{
      "ago" => "назад",
      "from_now" => "через",
      "second" => "секунда",
      "seconds" => "секунд",
      "minute" => "минута",
      "minutes" => "минут",
      "hour" => "час",
      "hours" => "часов",
      "day" => "день",
      "days" => "дней"
    }
  }

  @default_locale "en"

  @doc """
  Converts a duration (in milliseconds or DateTime) into a human-readable string, with localization support.

  ## Options

    - `:locale` - the locale to use (default: "en").

  ## Examples

      iex> HumanTime.human(754000)
      "12 minutes from now"

      iex> HumanTime.human(754000, locale: "fr")
      "dans 12 minutes"

  """
  @spec human(integer() | DateTime.t(), keyword()) :: String.t()
  def human(input, opts \\ []) do
    locale = Keyword.get(opts, :locale, @default_locale)
    translations = Map.get(@locales, locale, @locales[@default_locale])

    seconds =
      case input do
        %DateTime{} = date -> DateTime.to_unix(date) - DateTime.to_unix(DateTime.utc_now())
        ms when is_integer(ms) -> div(ms, 1000)
      end

    human_diff(seconds, translations)
  end

  defp human_diff(seconds, translations) when seconds < 0 do
    time_phrase(-seconds, translations) <> " " <> translations["ago"]
  end

  defp human_diff(seconds, translations) when seconds >= 0 do
    translations["from_now"] <> " " <> time_phrase(seconds, translations)
  end

  defp time_phrase(seconds, translations) when seconds < 60 do
    unit = if seconds == 1, do: translations["second"], else: translations["seconds"]
    "#{seconds} #{unit}"
  end

  defp time_phrase(seconds, translations) when seconds < 3600 do
    minutes = div(seconds, 60)
    unit = if minutes == 1, do: translations["minute"], else: translations["minutes"]
    "#{minutes} #{unit}"
  end

  defp time_phrase(seconds, translations) when seconds < 86_400 do
    hours = div(seconds, 3600)
    unit = if hours == 1, do: translations["hour"], else: translations["hours"]
    "#{hours} #{unit}"
  end

  defp time_phrase(seconds, translations) do
    days = div(seconds, 86_400)
    unit = if days == 1, do: translations["day"], else: translations["days"]
    "#{days} #{unit}"
  end
end

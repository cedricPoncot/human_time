# HumanTime

A library to show milliseconds or `DateTime` values in a human-readable form (`12 minutes from now`, `há 1 hora`, etc). It supports multiple locales for flexible internationalization.

## Features

- Converts durations (in milliseconds) into human-readable strings.
- Supports both positive (future) and negative (past) durations.
- Handles `DateTime` objects for precise time intervals.
- Multilingual support for the following locales: English (`en`), French (`fr`), Spanish (`es`), Chinese (`zh`), Russian (`ru`), and Portuguese (``pt``).
- **Verbose output**: Allows specifying the level of detail in the output.

### Example Outputs:

| Input                  | Output                |
|------------------------|-----------------------|
| `754000`              | "12 minutes from now" |
| `-754000`             | "12 minutes ago"      |
| `DateTime.utc_now() \|> DateTime.add(15s)`   | "15 seconds from now" |
| `DateTime.utc_now() \|> DateTime.add(90061s)` | "in 1 day" |
| `DateTime.utc_now() \|> DateTime.add(-15s)`  | "15 seconds ago"      |

### Localized Outputs:

| Locale | Input                  | Output                |
|--------|------------------------|-----------------------|
| `fr`   | `-3600s`              | "il y a 1 heure"     |
| `fr`   | `120s`                | "dans 2 minutes"     |
| `es`   | `-3600s`              | "hace 1 hora"        |
| `pt`   | `-3600s`              | "há 1 hora"        |
| `zh`   | `120s`                | "2 分钟后"  |

---

## Installation

Add `human_time` to your list of dependencies in your `mix.exs` file:

```elixir
def deps do
  [
    {:human_time, "~> 0.2.0"}
  ]
end
```

Fetch the dependencies:

```bash
mix deps.get
```

---

## Usage

Here are examples of how to use `HumanTime`:

```elixir
# Duration in milliseconds
HumanTime.human(754000)
# Output: "12 minutes from now"

HumanTime.human(-754000)
# Output: "12 minutes ago"

# Using DateTime
future_time = DateTime.utc_now() |> DateTime.add(15, :second)
HumanTime.human(future_time)
# Output: "15 seconds from now"

past_time = DateTime.utc_now() |> DateTime.add(-15, :second)
HumanTime.human(past_time)
# Output: "15 seconds ago"

# Localized output
HumanTime.human(past_time, locale: "fr")
# Output: "il y a 1 heure"

HumanTime.human(future_time, locale: "fr", verbose: 2)
# Output: "dans 2 minutes, 10 secondes"
```

---

## Localization Support

The following locales are supported:

- English (`en`)
- French (`fr`)
- Spanish (`es`)
- Chinese (`zh`)
- Russian (`ru`)
- Portuguese (`pt`)

If the provided locale is not supported, the default (`en`) is used.

---


## Contributing

Contributions are welcome! To add support for additional locales or improve functionality:

---

## License

`HumanTime` is available under the [MIT License](LICENSE).


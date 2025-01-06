# Show milliseconds in a human-readable form

DateTime is also supported in human-readable form

X seconds|minutes|hours|days| from now|ago

https://hex.pm/packages/sort_keys


## Installation

 In `mix.exs` file:

```elixir
def deps do
  [
    {:human_time, "~> 0.1.0"}
  ]
end
```

## Usage

```elixir

HumanTime.human(754000)
"12 minutes from now"

HumanTime.human(-754000)
"12 minutes ago"

HumanTime.human(DateTime.utc_now() |> DateTime.add(15, :second))
"15 seconds from now"

HumanTime.human(DateTime.utc_now() |> DateTime.add(-15, :second))
"15 seconds ago"

```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/human_time>.


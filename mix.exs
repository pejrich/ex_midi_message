defmodule MidiMessage.MixProject do
  use Mix.Project

  def project do
    [
      app: :midi_message,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_paths: [
        "lib",
        "examples/universal_system_exclusive/lib"
      ],
      test_paths: [
        "test",
        "examples/universal_system_exclusive/test"
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:faker, "~> 0.17", only: :test}
    ]
  end
end

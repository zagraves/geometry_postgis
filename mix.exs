defmodule Strabo.Mixfile do
  use Mix.Project

  @source_url "https://github.com/zagraves/strabo"
  @version "0.1.1"

  def project do
    [
      app: :strabo,
      version: @version,
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      name: "GeoPostGIS",
      deps: deps(),
      package: package(),
      docs: docs(),
      elixirc_paths: elixirc_paths(Mix.env())
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:geometry, "~> 0.4.0"},
      {:postgrex, ">= 0.0.0"},
      {:jason, "~> 1.2"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:ecto_sql, "~> 3.0", optional: true, only: :test}
    ]
  end

  defp package do
    [
      description: "Geometry/PostGIS extension for Postgrex.",
      files: ["lib", "mix.exs", "README.md", "CHANGELOG.md"],
      maintainers: ["Zach Graves"],
      licenses: ["MIT"],
      links: %{"GitHub" => @source_url}
    ]
  end

  defp docs do
    [
      extras: ["CHANGELOG.md", "README.md"],
      main: "readme",
      source_url: @source_url,
      source_ref: "v#{@version}",
      formatters: ["html"]
    ]
  end
end

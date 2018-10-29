defmodule CachedApiGateway.MixProject do
  use Mix.Project

  def project do
    [
      app: :cached_api_gateway,
      version: "0.1.0",
      elixir: "~> 1.6",
      deps: deps(),
      escript: escript(),
      description: "Cached API gateway"
    ]
  end

  def application do
    [
      applications: applications(Mix.env),
      mod: {CachedApiGateway.Application, []}
    ]
  end

  defp applications(:dev), do: applications(:all) ++ [:remix]
  defp applications(_all), do: [:logger, :rackla, :cowboy]

  defp deps do
    [
      {:rackla, "~> 1.2"},
      {:cowboy, "~> 1.0"},
      {:plug_cowboy, "~> 1.0"},
      {:remix, "~> 0.0", only: :dev},
    ]
  end

  def escript do
    [main_module: CachedApiGateway.Application]
  end
end

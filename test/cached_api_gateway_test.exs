defmodule CachedApiGatewayTest do
  use ExUnit.Case
  doctest CachedApiGateway

  test "greets the world" do
    assert CachedApiGateway.hello() == :world
  end
end

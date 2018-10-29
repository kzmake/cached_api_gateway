defmodule CachedApiGateway.Cache do
  use Nebulex.Cache, otp_app: :cached_api_gateway
end

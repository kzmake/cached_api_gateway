defmodule CachedApiGateway.Router do
  @moduledoc false

  use Plug.Router
  import Rackla

  plug :match
  plug :dispatch

  match "/api/", host: "jp-east-1.computing." do
    host = conn.host
    query_string = conn.query_string
    method = conn.method

    %{method: method, url: "https://#{host}/api/", body: "#{query_string}"}
    |> request
    |> response
  end

  match "/cached_api/", host: "jp-east-1.computing." do
    host = conn.host
    query_string = conn.query_string
    method = conn.method

    %{method: method, url: "https://#{host}/api/", body: "#{query_string}"}
    |> request
    |> response
  end

  match _ do
    send_resp(conn, 404, "Not found")
  end
end

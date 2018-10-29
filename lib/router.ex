defmodule CachedApiGateway.Router do
  @moduledoc false

  use Plug.Router
  import Rackla

  plug(:match)
  plug(:dispatch)

  match "/api/", host: "jp-east-1.computing." do
    host = conn.host
    query_string = conn.query_string
    method = conn.method

    {_, _status_code, _headers, client_ref} =
      :hackney.request(method, "https://#{host}/api/", [], "#{query_string}", [])

    {:ok, body} = :hackney.body(client_ref)

    body |> just |> response
  end

  match "/cached_api/", host: "jp-east-1.computing." do
    host = conn.host
    query_string = conn.query_string
    method = conn.method

    [_ | [access_key_id | _]] = Regex.run(~r/.*AccessKeyId=([0-9A-Z]*).*/, query_string)
    [_ | [action | _]] = Regex.run(~r/.*Action=([A-Za-z0-9]*).*/, query_string)

    key = "#{access_key_id}#{action}"

    body =
      case CachedApiGateway.Cache.has_key?(key) do
        true ->
          IO.inspect("cached")
          CachedApiGateway.Cache.get(key)

        _ ->
          IO.inspect("uncached")
          {_, _status_code, _headers, client_ref} =
            :hackney.request(method, "https://#{host}/api/", [], "#{query_string}", [])

          {:ok, body} = :hackney.body(client_ref)
          CachedApiGateway.Cache.set(key, body)

          body
      end

    body |> just |> response
  end

  match _ do
    send_resp(conn, 404, "Not found")
  end
end

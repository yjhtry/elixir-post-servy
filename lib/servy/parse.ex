defmodule Servy.Parse do
  alias Servy.Conv

  def parse(request) do
    [top, body] =
      case String.split(request, "\r\n\r\n") do
        [top, body] -> [top, body]
        [top] -> [top, ""]
      end

    [request_line | header_lines] = String.split(top, "\r\n")

    [method, path, _] = String.split(request_line, " ")

    headers = parse_headers(header_lines, %{})

    %Conv{
      method: method,
      path: path,
      params: parse_params(headers["Content-Type"], String.replace(body, ~r"\r|\n", "")),
      headers: headers
    }
  end

  def parse_params("application/x-www-form-urlencoded", params) do
    URI.decode_query(params)
  end

  def parse_params(_, _), do: %{}

  def parse_headers([head | tail], headers) do
    [key, value] = String.split(head, ": ")

    headers = Map.put(headers, key, value)

    parse_headers(tail, headers)
  end

  def parse_headers([], headers), do: headers
end

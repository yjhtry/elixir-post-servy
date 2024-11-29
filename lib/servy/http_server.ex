defmodule Servy.HttpServer do
  def start(port) when is_integer(port) and port > 1023 do
    {:ok, listen_socket} =
      :gen_tcp.listen(port, [:binary, packet: :raw, active: false, reuseaddr: true])

    IO.puts("Listening on port #{port}")
    accept_loop(listen_socket)
  end

  defp accept_loop(listen_socket) do
    {:ok, client_socket} = :gen_tcp.accept(listen_socket)

    spawn(fn -> server(client_socket) end)

    accept_loop(listen_socket)
  end

  defp server(client_socket) do
    client_socket
    |> read_request()
    |> Servy.Handler.handle()
    |> send_response(client_socket)
  end

  defp read_request(socket) do
    {:ok, request} = :gen_tcp.recv(socket, 0)
    request
  end

  defp send_response(response, socket) do
    :gen_tcp.send(socket, response)
    :gen_tcp.close(socket)
  end
end

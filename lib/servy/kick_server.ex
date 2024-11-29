defmodule Servy.KickServer do
  use GenServer

  def start_link(_arg) do
    IO.puts("Starting Servy.KickServer...")
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    Process.flag(:trap_exit, true)
    server_pid = start_server()

    {:ok, server_pid}
  end

  def handle_info({:EXIT, _pid, reason}, _state) do
    IO.puts("HttpServer exited (#{inspect(reason)})")

    server_pid = start_server()

    {:noreply, server_pid}
  end

  def start_server() do
    port = Application.get_env(:servy, :port)
    server_pid = spawn_link(Servy.HttpServer, :start, [port])
    IO.puts("Start HttpServer...")
    Process.register(server_pid, :http_server)

    server_pid
  end
end

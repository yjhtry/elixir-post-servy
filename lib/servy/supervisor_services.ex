defmodule Servy.SupervisorServices do
  use Supervisor

  def start_link(_arg) do
    IO.puts("Starting Servy.SupervisorServices...")
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = [
      Servy.PostGenServer,
      {Servy.SnapshotGenServer, 60}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end

defmodule Servy.SnapshotGenServer do
  import Servy.SnapshotServer, only: [get_snapshot: 1]

  @name :snapshot_gen_server
  @delay :timer.minutes(60)

  use GenServer

  def init(_args) do
    snapshots = get_snapshots()

    schedule_refresh()
    {:ok, snapshots}
  end

  def start_link(interval) do
    IO.puts("Starting the sensor server with #{interval} min refresh...")
    GenServer.start_link(__MODULE__, [], name: @name)
  end

  def handle_info(:refresh, _state) do
    snapshots = get_snapshots()
    schedule_refresh()
    {:noreply, snapshots}
  end

  defp get_snapshots() do
    snapshots =
      ["lei", "john", "kui"]
      |> Enum.map(&Task.async(fn -> get_snapshot(&1) end))
      |> Enum.map(&Task.await/1)

    IO.inspect("New snapshots: #{inspect(snapshots)}")

    snapshots
  end

  defp schedule_refresh() do
    Process.send_after(self(), :refresh, @delay)
  end
end

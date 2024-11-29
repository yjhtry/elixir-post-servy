defmodule Servy.SnapshotServer do
  def get_snapshot(name) do
    :timer.sleep(1000)
    "Snapshot: #{name}-#{:rand.uniform(1000)}.jpg"
  end
end

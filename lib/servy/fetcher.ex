defmodule Servy.Fetcher do
  def async(callback) do
    parent = self()

    spawn(fn -> send(parent, {self(), :result, callback.()}) end)
  end

  def await(pid) do
    receive do
      {^pid, :result, value} -> value
    end
  end
end

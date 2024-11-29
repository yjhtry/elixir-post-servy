defmodule Servy.PostGenServer do
  @name :post_gen_server

  use GenServer

  def init(init_arg) do
    {:ok, init_arg}
  end

  def start() do
    GenServer.start(__MODULE__, [], name: @name)
  end

  def create_post(name, body) do
    GenServer.call(@name, {:create_post, name, body})
  end

  def get_recent_posts() do
    GenServer.call(@name, :get_recent_post)
  end

  def clear() do
    GenServer.cast(@name, :clear)
  end

  def handle_call({:create_post, name, body}, _from, state) do
    new_post = %{id: generate_id(), name: name, body: body}
    state = [new_post | Enum.take(state, 2)]

    {:reply, new_post, state}
  end

  def handle_call(:get_recent_post, _from, state) do
    {:reply, state, state}
  end

  def handle_cast(:clear, _state) do
    {:noreply, []}
  end

  def handle_info(msg, state) do
    IO.inspect("Can't touch this! #{inspect(msg)}")
    {:noreply, state}
  end

  defp generate_id() do
    :rand.uniform(1000)
  end
end

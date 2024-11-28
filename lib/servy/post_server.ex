defmodule Servy.GenericServer do
  def start(callback_module, init_state, name) do
    pid = spawn(__MODULE__, :listen_loop, [init_state, callback_module])

    Process.register(pid, name)

    pid
  end

  def listen_loop(state, callback_module) do
    receive do
      {:call, sender, message} when is_pid(sender) ->
        {response, new_state} = callback_module.handle_call(message, state)
        send(sender, {:response, response})

        listen_loop(new_state, callback_module)

      {:cast, message} ->
        new_state = callback_module.handle_cast(message, state)

        listen_loop(new_state, callback_module)

      unexpected ->
        IO.inspect("Unexpected message: #{inspect(unexpected)}")
        listen_loop(state, callback_module)
    end
  end

  def call(pid, message) do
    send(pid, {:call, self(), message})

    receive do
      {:response, response} -> response
    end
  end

  def cast(pid, message) do
    send(pid, {:cast, message})
  end
end

defmodule Servy.PostServer do
  @name :post_server

  def start() do
    Servy.GenericServer.start(__MODULE__, [], @name)
  end

  def create_post(name, body) do
    Servy.GenericServer.call(@name, {:create_post, name, body})
  end

  def get_recent_posts() do
    Servy.GenericServer.call(@name, :get_recent_post)
  end

  def clear() do
    Servy.GenericServer.cast(@name, :clear)
  end

  def handle_call({:create_post, name, body}, state) do
    new_post = %{id: generate_id(), name: name, body: body}
    state = [new_post | Enum.take(state, 2)]

    {new_post, state}
  end

  def handle_call(:get_recent_post, state) do
    {state, state}
  end

  def handle_cast(:clear, _state) do
    []
  end

  defp generate_id() do
    :rand.uniform(1000)
  end
end

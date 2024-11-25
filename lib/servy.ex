defmodule Servy do
  use Application
  alias Servy.Handler

  def start(_type, _args) do
    run()
    Supervisor.start_link([], strategy: :one_for_one)
  end

  def run do
    request = """
    GET /api/posts HTTP/1.1\r
    Host: localhost:4000\r
    User-Agent: curl/7.64.1\r
    Content-Type: application/x-www-form-urlencoded\r
    \r
    """

    IO.puts(Handler.handle(request))
  end
end

defmodule Servy.Handler do
  @moduledoc "Handle HTTP requests"

  @pages_dir Path.expand("../../pages", __DIR__)

  import Servy.Parse, only: [parse: 1]
  import Servy.Plugins, only: [rewrite_path: 1, log: 1, trace: 1]
  alias Servy.Conv
  alias Servy.PostController
  alias Servy.Api

  @doc "Transform a request into a response"
  def handle(request) do
    request
    |> parse
    |> rewrite_path
    |> log
    |> route
    |> trace
    |> fmt_response
  end

  def route(%Conv{method: "GET", path: "/sleep/" <> time} = conv) do
    time |> String.to_integer() |> :timer.sleep()
    %Conv{conv | resp_body: "Slept for #{time} ms"}
  end

  def route(%Conv{method: "GET", path: "/"} = conv) do
    PostController.index(conv)
  end

  def route(%Conv{method: "GET", path: "/api/posts"} = conv) do
    Api.PostController.index(conv)
  end

  def route(%Conv{method: "GET", path: "/post/" <> id} = conv) do
    params = Map.put(conv.params, "id", id)

    PostController.post(conv, params)
  end

  def route(%Conv{method: "POST", path: "/post"} = conv) do
    PostController.create(conv, conv.params)
  end

  def route(%Conv{method: "GET", path: "/about"} = conv) do
    @pages_dir
    |> Path.join("about.html")
    |> File.read()
    |> handle_file(conv)
  end

  def route(%Conv{path: path} = conv) do
    %{conv | status: 404, resp_body: "#{path} path not found"}
  end

  def handle_file({:ok, content}, %Conv{} = conv) do
    %{conv | status: 200, resp_body: content}
  end

  def handle_file({:error, reason}, %Conv{} = conv) do
    %{conv | status: 500, resp_body: "Read file error: #{:file.format_error(reason)}"}
  end

  def fmt_response(%Conv{} = conv) do
    """
    HTTP/1.1 #{Conv.full_status(conv)}
    Content-Length: #{byte_size(conv.resp_body)}
    Content-Type: text/html

    #{conv.resp_body}
    """
  end
end

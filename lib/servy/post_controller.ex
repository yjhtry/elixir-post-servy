defmodule Servy.PostController do
  alias Servy.PostServer
  import Servy.Post

  @templates_path Path.expand("../../templates", __DIR__)

  defp render(conv, template, bindings) do
    content =
      @templates_path
      |> Path.join(template)
      |> EEx.eval_file(bindings)

    %{conv | status: 200, resp_body: content}
  end

  def index(conv) do
    posts =
      list_posts()
      |> Enum.sort(&(&1.id < &2.id))

    render(conv, "index.html.eex", posts: posts)
  end

  def post(conv, %{"id" => id}) do
    post = get_post(id)

    render(conv, "post.html.eex", post: post)
  end

  def create(conv, %{"title" => title, "body" => body}) do
    {:response, post} = PostServer.create_post(title, body)

    %{
      conv
      | status: 200,
        resp_body: "Post created: #{post.id}"
    }
  end

  def get_recent(conv) do
    posts = PostServer.get_recent_posts()

    %{
      conv
      | status: 200,
        resp_body: inspect(posts)
    }
  end
end

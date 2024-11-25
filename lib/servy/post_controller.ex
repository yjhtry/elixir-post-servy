defmodule Servy.PostController do
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

  def create(conv, %{"id" => id, "title" => title}) do
    %{
      conv
      | status: 200,
        resp_body: "The Post is is #{id} title is #{title}"
    }
  end
end

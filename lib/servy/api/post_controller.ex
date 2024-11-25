defmodule Servy.Api.PostController do
  alias Servy.Post
  alias Servy.Conv

  def index(%Conv{} = conv) do
    content =
      Post.list_posts()
      |> Poison.encode!()

    %{conv | status: 200, resp_body: content}
  end
end

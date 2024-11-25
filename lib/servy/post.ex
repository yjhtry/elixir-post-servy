defmodule Servy.Post do
  def list_posts() do
    [
      %{
        id: 1,
        title: "First Post",
        body: "This is the first post"
      },
      %{
        id: 2,
        title: "Second Post",
        body: "This is the second post"
      },
      %{
        id: 3,
        title: "Third Post",
        body: "This is the third post"
      },
      %{
        id: 4,
        title: "Fourth Post",
        body: "This is the fourth post"
      },
      %{
        id: 5,
        title: "Fifth Post",
        body: "This is the fifth post"
      },
      %{
        id: 6,
        title: "Sixth Post",
        body: "This is the sixth post"
      }
    ]
  end

  def get_post(id) when is_integer(id) do
    list_posts()
    |> Enum.find(&(&1.id == id))
  end

  def get_post(id) when is_binary(id) do
    id
    |> String.to_integer()
    |> get_post()
  end
end

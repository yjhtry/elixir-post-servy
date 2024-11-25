defmodule Servy.Plugins do
  alias Servy.Conv

  def trace(%Conv{status: 404, path: path} = conv) do
    %{conv | resp_body: "#{path} not found"}
  end

  def trace(%Conv{} = conv), do: conv

  def rewrite_path(%Conv{method: "GET", path: "/post"} = conv) do
    %{conv | path: "/post/1"}
  end

  def rewrite_path(%Conv{} = conv), do: conv

  def log(%Conv{} = conv) do
    if Mix.env() !== :test do
      IO.inspect(conv)
    end

    conv
  end
end

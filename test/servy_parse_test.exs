defmodule ServyParseTest do
  use ExUnit.Case

  alias Servy.Parse

  test "parse application/x-www-form-urlencoded" do
    request = """
    GET / HTTP/1.1\r
    Host: localhost:4000\r
    User-Agent: curl/7.64.1\r
    Content-Type: application/x-www-form-urlencoded\r
    \r
    id=1&title=rust-learn
    """

    conv = Parse.parse(request)

    assert conv.method == "GET"
    assert conv.path == "/"
    assert conv.params == %{"id" => "1", "title" => "rust-learn"}

    assert conv.headers == %{
             "Host" => "localhost:4000",
             "User-Agent" => "curl/7.64.1",
             "Content-Type" => "application/x-www-form-urlencoded"
           }
  end

  test "parse other content type" do
    request = """
    GET / HTTP/1.1\r
    Host: localhost:4000\r
    User-Agent: curl/7.64.1\r
    Content-Type: multipart/form-data\r
    \r
    {"id": 1, "title": "rust-learn"}
    """

    conv = Parse.parse(request)

    assert conv.method == "GET"
    assert conv.path == "/"
    assert conv.params == %{}

    assert conv.headers == %{
             "Host" => "localhost:4000",
             "User-Agent" => "curl/7.64.1",
             "Content-Type" => "multipart/form-data"
           }
  end
end

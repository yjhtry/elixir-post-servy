defmodule ServyHandlerTest do
  use ExUnit.Case
  doctest Servy.Handler

  alias Servy.Handler

  test "request posts" do
    request = """
    GET / HTTP/1.1\r
    Host: localhost:4000\r
    User-Agent: curl/7.64.1\r
    Content-Type: application/x-www-form-urlencoded\r
    \r
    """

    response = Handler.handle(request)

    assert remove_whitespace(response) ==
             remove_whitespace("""
             HTTP/1.1 200 OK
             Content-Length: 528
             Content-Type: text/html

             <h1>My posts</h1>

               <article>
                 <h2>First Post</h2>
                 <p>This is the first post</p>
               </article>

               <article>
                 <h2>Second Post</h2>
                 <p>This is the second post</p>
               </article>

               <article>
                 <h2>Third Post</h2>
                 <p>This is the third post</p>
               </article>

               <article>
                 <h2>Fourth Post</h2>
                 <p>This is the fourth post</p>
               </article>

               <article>
                 <h2>Fifth Post</h2>
                 <p>This is the fifth post</p>
               </article>

               <article>
                 <h2>Sixth Post</h2>
                 <p>This is the sixth post</p>
               </article>
             """)
  end

  test "get post by id" do
    request = """
    GET /post/1 HTTP/1.1\r
    Host: localhost:4000\r
    User-Agent: curl/7.64.1\r
    Content-Type: application/x-www-form-urlencoded\r
    \r
    """

    response = Handler.handle(request)

    assert remove_whitespace(response) ==
             remove_whitespace("""
             HTTP/1.1 200 OK
             Content-Length: 51
             Content-Type: text/html

             <h1>First Post</h1>

             <p>This is the first post</p>
             """)
  end

  test "handler application/json" do
    request = """
    GET /api/posts HTTP/1.1\r
    Host: localhost:4000\r
    User-Agent: curl/7.64.1\r
    Content-Type: application/json\r
    \r
    """

    response = Handler.handle(request)

    assert remove_whitespace(response) ==
             remove_whitespace("""
             HTTP/1.1 200 OK
             Content-Length: 377
             Content-Type: text/html

             [{"body":"This is the first post","title":"First Post","id":1},{"body":"This is the second post","title":"Second Post","id":2},{"body":"This is the third post","title":"Third Post","id":3},{"body":"This is the fourth post","title":"Fourth Post","id":4},{"body":"This is the fifth post","title":"Fifth Post","id":5},{"body":"This is the sixth post","title":"Sixth Post","id":6}]
             """)
  end

  def remove_whitespace(str) do
    String.replace(str, ~r/\s+/, "")
  end
end

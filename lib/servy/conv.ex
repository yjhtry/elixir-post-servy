defmodule Servy.Conv do
  defstruct method: "", path: "", status: nil, resp_body: "", headers: %{}, params: %{}

  def full_status(conv) do
    "#{conv.status} #{status_reason(conv.status)}"
  end

  defp status_reason(status) do
    case status do
      200 -> "OK"
      201 -> "Created"
      400 -> "Bad Request"
      401 -> "Unauthorized"
      403 -> "Forbidden"
      404 -> "Not Found"
      500 -> "Internal Server Error"
      501 -> "Not Implemented"
      _ -> "Unknown"
    end
  end
end

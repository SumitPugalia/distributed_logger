defmodule DistributedLoggerWeb.Router do
  use DistributedLoggerWeb, :router

  defp copy_req_body(conn, _) do
    {:ok, body, _} = Plug.Conn.read_body(conn)
    Plug.Conn.put_private(conn, :raw_body, body)
  end

  pipeline :api do
    plug :accepts, ["text"]
    plug :copy_req_body
  end

  # Other scopes may use custom stacks.
  scope "/", DistributedLoggerWeb do
    pipe_through :api
    post "/event", LoggerController, :create
  end
end

defmodule DistributedLoggerWeb.LoggerController do
  use DistributedLoggerWeb, :controller
  
  alias DistributedLogger.Logger

  def create(conn, _params) do
    Logger.log(conn.private[:raw_body])
    
    conn
    |> Plug.Conn.send_resp(:ok, "")
  end
end
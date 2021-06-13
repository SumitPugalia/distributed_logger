defmodule DistributedLoggerWeb.LoggerControllerTest do
  use DistributedLoggerWeb.ConnCase

  test "Post /event", %{conn: conn} do
  	:ok = LocalCluster.start()
  	nodes = LocalCluster.start_nodes("cluster", 3)
  	path = 
        Path.expand("./nodes/")
        |> Path.absname()

    ## Remove the log folder
    File.rm_rf(path)

    conn = conn |> put_req_header("content-type", "text/plain")
    _conn = post(conn, "/event", "test-event-controller")
    
    ## Check log folder of each node
    Enum.each([Node.self() | nodes] , fn node ->
      path = 
        Path.expand("./nodes/" <> Atom.to_string(node) <> "/data/events.log")
        |> Path.absname()

      {:ok, message} = File.read(path)
      [_, event | _] = String.split(message, [" ", "\n"])
      
      assert event == "test-event-controller"
    end)
    
    ## Delete the folder
    File.rm_rf!(path)

    :ok = LocalCluster.stop()
  end
end
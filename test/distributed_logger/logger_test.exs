defmodule DistributedLogger.LoggerTest do
  use ExUnit.Case
  alias DistributedLogger.Logger
  
  test "logger event" do
    :ok = LocalCluster.start()
    ## Start Three Nodes
    nodes = LocalCluster.start_nodes("cluster", 3)

    [node1, node2, node3] = nodes

    ## Verify Nodes are connected
    assert Node.ping(node1) == :pong
    assert Node.ping(node2) == :pong
    assert Node.ping(node3) == :pong
    
    path = 
        Path.expand("./nodes/")
        |> Path.absname()

    ## Remove the log folder
    File.rm_rf(path)

    ## Call the log Function
    Logger.log("test-event")
    
    ## Check log folder of each node
    Enum.each([Node.self() | nodes] , fn node ->
      path = 
        Path.expand("./nodes/" <> Atom.to_string(node) <> "/data/events.log")
        |> Path.absname()

      {:ok, message} = File.read(path)
      [_, event | _] = String.split(message, [" ", "\n"])
      
      assert event == "test-event"
    end)
    
    ## Delete the folder
    File.rm_rf!(path)
    :ok = LocalCluster.stop()

    assert Node.ping(node1) == :pang
    assert Node.ping(node2) == :pang
    assert Node.ping(node3) == :pang
  end
end

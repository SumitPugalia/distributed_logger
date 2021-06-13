defmodule DistributedLogger.Logger do
  @moduledoc """
  This is the DistributedLogger module.
  """

  @doc """
  Function to trigger the write function on all the clustered nodes.
  """

  @spec log(String.t) :: :ok
  def log(event) do  
    ## Why do I append the SELF NODE for RPC ?
    ## BECAUSE, The same log function cannot be used to write to file.
    ## If we do so it will endup being called recursively.
    ## Example: Node A will call Node B and Node C,
    ## Again, Node B will call Node A and Node C.. 
    ## This will go on for the single request.

    nodes = [Node.self() | Node.list()]

    ## I didn't handle the error case when rpc fails
    _ = :rpc.multicall(nodes, __MODULE__, :write, [event])
    :ok
  end

  @doc """
  Function to write the logs (timestamp + event) in the file.
  """
  @spec write(String.t) :: :ok
  def write(event) do
  	path = Path.expand("./nodes/" <> Atom.to_string(Node.self()) <> "/data/events.log")
  	|> Path.absname()
  	
  	with :ok <- File.mkdir_p(Path.dirname(path)) do
  		now = 
  			DateTime.utc_now() 
  			|> DateTime.to_unix() 
  			|> to_string()

  		message = now <> " " <> event <> "\n"
  		case File.write(path, message, [:append]) do
        :ok -> :ok
        {:error, posix} -> 
          IO.inspect(posix)
          :ok
      end
  	
    else
  		error -> 
  			IO.inspect(error)
        :ok
  	end
  end
end
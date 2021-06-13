defmodule DistributedLogger.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    ## Connect the Node
    {:ok, node} = Application.fetch_env(:distributed_logger, :cluster)
    
    if node != nil and node != Node.self() do
      true = Node.connect(String.to_atom(node))
    end

    # List all child processes to be supervised
    children = [
      # Start the endpoint when the application starts
      DistributedLoggerWeb.Endpoint
      # Starts a worker by calling: DistributedLogger.Worker.start_link(arg)
      # {DistributedLogger.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: DistributedLogger.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    DistributedLoggerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

defmodule Inskedular.Application do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(Inskedular.Repo, []),
      # Start the endpoint when the application starts
      supervisor(InskedularWeb.Endpoint, []),
      # Start your own worker by calling: Inskedular.Worker.start_link(arg1, arg2, arg3)
      # worker(Inskedular.Worker, [arg1, arg2, arg3]),

      # Scheduling supervisor
      supervisor(Inskedular.Scheduling.Supervisor, []),

      # Async task supervisor
      supervisor(Task.Supervisor, [[name: Inskedular.TaskSupervisor]]),

      # process managers
      worker(Inskedular.Scheduling.ProcessManagers.ScheduleProcessManager, []),
      worker(Inskedular.Scheduling.ProcessManagers.MatchProcessManager, []),

      # Misc
      worker(Inskedular.Support.Unique, []),
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Inskedular.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    InskedularWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

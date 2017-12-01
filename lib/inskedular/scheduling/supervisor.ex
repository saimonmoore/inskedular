defmodule Inskedular.Scheduling.Supervisor do
  use Supervisor

  alias Inskedular.Scheduling

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_arg) do
    Supervisor.init([
      Scheduling.Projectors.Schedule,
      Scheduling.Projectors.Team,
      Scheduling.Projectors.Match,
    ], strategy: :one_for_one)
  end
end

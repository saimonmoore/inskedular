defmodule Inskedular.Scheduling.Agregates.TeamLifespan do
  @behaviour Commanded.Aggregates.AggregateLifespan

  alias Inskedular.Scheduling.Commands.DestroyTeam

  def after_command(%DestroyTeam{}), do: 0
  def after_command(_), do: :infinity
end

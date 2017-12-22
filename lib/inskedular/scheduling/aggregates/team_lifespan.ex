defmodule Inskedular.Scheduling.Aggregates.TeamLifespan do
  @moduledoc false
  @behaviour Commanded.Aggregates.AggregateLifespan

  alias Inskedular.Scheduling.Commands.DestroyTeam

  def after_command(%DestroyTeam{}), do: 0
  def after_command(_), do: :infinity
end

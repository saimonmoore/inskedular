defmodule Inskedular.Scheduling.Aggregates.ScheduleLifespan do
  @behaviour Commanded.Aggregates.AggregateLifespan

  alias Inskedular.Scheduling.Commands.DestroySchedule

  def after_command(%DestroySchedule{}), do: 0
  def after_command(_), do: :infinity
end

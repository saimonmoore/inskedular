defmodule Inskedular.Router do
  use Commanded.Commands.Router

  alias Inskedular.Scheduling.Aggregates.Schedule
  alias Inskedular.Scheduling.Commands.CreateSchedule

  dispatch [CreateSchedule], to: Schedule, identity: :schedule_uuid
end

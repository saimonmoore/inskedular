defmodule Inskedular.Router do
  use Commanded.Commands.Router

  alias Inskedular.Scheduling.Aggregates.Schedule
  alias Inskedular.Scheduling.Commands.CreateSchedule
  alias Inskedular.Support.Middleware.Validate
  alias Inskedular.Support.Middleware.Uniqueness

  middleware Validate
  middleware Uniqueness

  dispatch [CreateSchedule], to: Schedule, identity: :schedule_uuid
end

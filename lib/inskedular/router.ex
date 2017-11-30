defmodule Inskedular.Router do
  use Commanded.Commands.Router

  alias Inskedular.Scheduling.Aggregates.{Schedule,Team}
  alias Inskedular.Scheduling.Commands.{CreateSchedule,CreateTeam}
  alias Inskedular.Support.Middleware.Validate
  alias Inskedular.Support.Middleware.Uniqueness

  middleware Validate
  middleware Uniqueness

  dispatch [CreateSchedule], to: Schedule, identity: :schedule_uuid
  dispatch [CreateTeam], to: Team, identity: :team_uuid
end

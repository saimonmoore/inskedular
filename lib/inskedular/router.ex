defmodule Inskedular.Router do
  use Commanded.Commands.Router

  alias Inskedular.Scheduling.Aggregates.{Schedule,Team,Match}
  alias Inskedular.Scheduling.Commands.{CreateSchedule,StartSchedule,IncludeMatchesInSchedule,CreateTeam,CreateMatch,UpdateMatch}
  alias Inskedular.Support.Middleware.Validate
  alias Inskedular.Support.Middleware.Uniqueness

  middleware Validate
  middleware Uniqueness

  dispatch [CreateSchedule,StartSchedule,IncludeMatchesInSchedule], to: Schedule, identity: :schedule_uuid
  dispatch [CreateTeam], to: Team, identity: :team_uuid
  dispatch [CreateMatch,UpdateMatch], to: Match, identity: :match_uuid
end

defmodule Inskedular.Router do
  use Commanded.Commands.Router

  alias Inskedular.Scheduling.Aggregates.{Schedule,Team,Match}
  alias Inskedular.Scheduling.Aggregates.{ScheduleLifespan,TeamLifespan}
  alias Inskedular.Scheduling.Commands.{CreateSchedule,DestroySchedule,StartSchedule,IncludeMatchesInSchedule,CreateTeam,UpdateTeam,DestroyTeam,CreateMatch,UpdateMatch}
  alias Inskedular.Support.Middleware.Validate
  alias Inskedular.Support.Middleware.Uniqueness

  middleware Validate
  middleware Uniqueness

  dispatch [CreateSchedule,DestroySchedule,StartSchedule,IncludeMatchesInSchedule], to: Schedule, identity: :schedule_uuid, lifespan: ScheduleLifespan
  dispatch [CreateTeam,UpdateTeam,DestroyTeam], to: Team, identity: :team_uuid, lifespan: TeamLifespan
  dispatch [CreateMatch,UpdateMatch], to: Match, identity: :match_uuid
end

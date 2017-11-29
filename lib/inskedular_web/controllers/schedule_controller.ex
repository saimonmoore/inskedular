defmodule InskedularWeb.ScheduleController do
  use InskedularWeb, :controller

  alias Inskedular.Scheduling
  alias Inskedular.Scheduling.Projections.Schedule

  action_fallback InskedularWeb.FallbackController

  def index(conn, params) do
    schedules = Scheduling.list_schedules(params)
    render(conn, "index.json", schedules: schedules)
  end

  def create(conn, schedule_params) do
    with {:ok, %Schedule{} = schedule} <- Scheduling.create_schedule(schedule_params) do
      conn
      |> put_status(:created)
      |> render("show.json", schedule: schedule)
    end
  end
end

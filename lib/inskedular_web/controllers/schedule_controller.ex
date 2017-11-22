defmodule InskedularWeb.ScheduleController do
  use InskedularWeb, :controller

  alias Inskedular.Scheduling
  alias Inskedular.Scheduling.Schedule

  action_fallback InskedularWeb.FallbackController

  def index(conn, _params) do
    schedules = Scheduling.list_schedules()
    render(conn, "index.json", schedules: schedules)
  end

  def create(conn, %{"schedule" => schedule_params}) do
    with {:ok, %Schedule{} = schedule} <- Scheduling.create_schedule(schedule_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", schedule_path(conn, :show, schedule))
      |> render("show.json", schedule: schedule)
    end
  end

  def show(conn, %{"id" => id}) do
    schedule = Scheduling.get_schedule!(id)
    render(conn, "show.json", schedule: schedule)
  end

  def update(conn, %{"id" => id, "schedule" => schedule_params}) do
    schedule = Scheduling.get_schedule!(id)

    with {:ok, %Schedule{} = schedule} <- Scheduling.update_schedule(schedule, schedule_params) do
      render(conn, "show.json", schedule: schedule)
    end
  end

  def delete(conn, %{"id" => id}) do
    schedule = Scheduling.get_schedule!(id)
    with {:ok, %Schedule{}} <- Scheduling.delete_schedule(schedule) do
      send_resp(conn, :no_content, "")
    end
  end
end

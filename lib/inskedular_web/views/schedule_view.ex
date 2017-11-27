defmodule InskedularWeb.ScheduleView do
  use InskedularWeb, :view
  use Inskedular.Support.Casting

  alias InskedularWeb.ScheduleView

  def render("index.json", %{schedules: schedules}) do
    %{data: render_many(schedules, ScheduleView, "schedule.json")}
  end

  def render("show.json", %{schedule: schedule}) do
    %{data: render_one(schedule, ScheduleView, "schedule.json")}
  end

  def render("schedule.json", %{schedule: schedule}) do
    {:ok, start_date} = cast_datetime(schedule.start_date)
    {:ok, end_date} = cast_datetime(schedule.end_date)
    %{uuid: schedule.uuid,
      name: schedule.name,
      start_date: start_date,
      end_date:  end_date,
      number_of_games: schedule.number_of_games,
      game_duration: schedule.game_duration}
  end
end

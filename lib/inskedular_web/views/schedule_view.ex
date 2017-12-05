defmodule InskedularWeb.ScheduleView do
  use InskedularWeb, :view
  use Inskedular.Support.Presenting

  alias InskedularWeb.ScheduleView

  def render("index.json", %{schedules: schedules}) do
    render_many(schedules, ScheduleView, "schedule.json")
  end

  def render("show.json", %{schedule: schedule}) do
    render_one(schedule, ScheduleView, "schedule.json")
  end

  def render("schedule.json", %{schedule: schedule}) do
    start_date = present_datetime(schedule.start_date)
    end_date = present_datetime(schedule.end_date)

    %{uuid: schedule.uuid,
      name: schedule.name,
      status: schedule.status,
      start_date: start_date,
      end_date:  end_date,
      number_of_games: schedule.number_of_games,
      number_of_weeks: schedule.number_of_weeks,
      game_duration: schedule.game_duration}
  end
end

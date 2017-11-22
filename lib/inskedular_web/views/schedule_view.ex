defmodule InskedularWeb.ScheduleView do
  use InskedularWeb, :view
  alias InskedularWeb.ScheduleView

  def render("index.json", %{schedules: schedules}) do
    %{data: render_many(schedules, ScheduleView, "schedule.json")}
  end

  def render("show.json", %{schedule: schedule}) do
    %{data: render_one(schedule, ScheduleView, "schedule.json")}
  end

  def render("schedule.json", %{schedule: schedule}) do
    %{id: schedule.id,
      name: schedule.name,
      start_date: schedule.start_date,
      end_date: schedule.end_date,
      number_of_games: schedule.number_of_games,
      game_duration: schedule.game_duration}
  end
end

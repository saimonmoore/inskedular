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
    %{name: schedule.name,
      start_date: DateTime.to_iso8601(schedule.start_date),
      end_date:  DateTime.to_iso8601(schedule.end_date),
      number_of_games: schedule.number_of_games,
      game_duration: schedule.game_duration}
  end
end

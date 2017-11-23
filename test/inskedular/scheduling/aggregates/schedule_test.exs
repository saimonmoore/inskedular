defmodule Inskedular.Scheduling.Aggregates.ScheduleTest do
  use Inskedular.AggregateCase, aggregate: Inskedular.Scheduling.Aggregates.Schedule

  alias Inskedular.Scheduling.Commands.CreateSchedule
  alias Inskedular.Scheduling.Events.ScheduleCreated

  describe "create schedule" do
    @tag :unit
    test "should succeed when valid" do
      schedule_uuid = UUID.uuid4()

      assert_events build(:create_schedule, schedule_uuid: schedule_uuid), [
        %ScheduleCreated{
          schedule_uuid: schedule_uuid,
          name: "Hack Week Tournament",
          number_of_games: 4,
          game_duration: 60,
          start_date: DateTime.from_iso8601("2017-11-20T14:00:00.000+02:00"),
          end_date: DateTime.from_iso8601("2017-12-01T14:00:00.000+02:00"),
        }
      ]
    end
  end
end

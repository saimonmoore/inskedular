defmodule InskedularWeb.ScheduleControllerTest do
  use InskedularWeb.ConnCase

  alias Inskedular.Scheduling
  alias Inskedular.Scheduling.Schedule

  def fixture(:schedule, attrs \\ []) do
    build_schedule_params(attrs) |> Scheduling.create_schedule()
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json") }
  end

  describe "list schedules" do
    setup [
      :create_schedules
    ]

    @web
    test "renders list of schedules", %{conn: conn} do
      conn = get conn, schedule_path(conn, :index)
      schedules = json_response(conn, 200)

      first_schedule = Enum.at(schedules, 0)
      second_schedule = Enum.at(schedules, 1)

      assert Map.delete(first_schedule, "uuid") == %{
        "game_duration"   => 60,
        "name"            => "Hack Week Tournament",
        "number_of_games" => 4,
        "start_date"      => "20-11-2017 12:00:00",
        "end_date"        => "01-12-2017 12:00:00",
      }

      assert Map.delete(second_schedule, "uuid") == %{
        "game_duration"   => 50,
        "name"            => "Crypto Tournament",
        "number_of_games" => 8,
        "start_date"      => "20-11-2017 12:00:00",
        "end_date"        => "01-12-2017 12:00:00",
      }
    end
  end

  describe "create schedule" do
    @tag :web
    test "creates and renders schedule when data is valid", %{conn: conn} do
      conn = post conn, schedule_path(conn, :create), build_schedule_params
      json = json_response(conn, 201)["data"]

      assert Map.delete(json, "uuid") == %{
        "game_duration"   => 60,
        "name"            => "Hack Week Tournament",
        "number_of_games" => 4,
        "start_date"      => "20-11-2017 12:00:00",
        "end_date"        => "01-12-2017 12:00:00",
      }
    end

    @tag :web
    test "does not create schedule and renders errors when data is invalid", %{conn: conn} do
      conn = post conn, schedule_path(conn, :create), build_schedule_params(name: "")
      assert json_response(conn, 422)["errors"] == %{
        "name" => [
          "can't be empty",
        ]
      }
    end

    @tag :web
    test "does not create schedule and renders errors when name is taken", %{conn: conn} do
      {:ok, _schedule} = fixture(:schedule)

      conn = post conn, schedule_path(conn, :create), build_schedule_params(name: "Hack Week Tournament")
      assert json_response(conn, 422)["errors"] == %{
        "name" => [
          "has already been taken",
        ]
      }
    end
  end
end

defmodule InskedularWeb.MatchControllerTest do
  use InskedularWeb.ConnCase

  alias Inskedular.Scheduling
  alias Inskedular.Scheduling.Match

  @create_attrs %{away_team_uuid: "some away_team_uuid", end_date: "2010-04-17 14:00:00.000000Z", local_team_uuid: "some local_team_uuid", match_number: 42, match_uuid: "some match_uuid", result: "some result", schedule_uuid: "some schedule_uuid", score_away_team: 42, score_local_team: 42, start_date: "2010-04-17 14:00:00.000000Z", status: "some status"}
  @update_attrs %{away_team_uuid: "some updated away_team_uuid", end_date: "2011-05-18 15:01:01.000000Z", local_team_uuid: "some updated local_team_uuid", match_number: 43, match_uuid: "some updated match_uuid", result: "some updated result", schedule_uuid: "some updated schedule_uuid", score_away_team: 43, score_local_team: 43, start_date: "2011-05-18 15:01:01.000000Z", status: "some updated status"}
  @invalid_attrs %{away_team_uuid: nil, end_date: nil, local_team_uuid: nil, match_number: nil, match_uuid: nil, result: nil, schedule_uuid: nil, score_away_team: nil, score_local_team: nil, start_date: nil, status: nil}

  def fixture(:match) do
    {:ok, match} = Scheduling.create_match(@create_attrs)
    match
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all matches", %{conn: conn} do
      conn = get conn, match_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create match" do
    test "renders match when data is valid", %{conn: conn} do
      conn = post conn, match_path(conn, :create), match: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, match_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "away_team_uuid" => "some away_team_uuid",
        "end_date" => "2010-04-17 14:00:00.000000Z",
        "local_team_uuid" => "some local_team_uuid",
        "match_number" => 42,
        "match_uuid" => "some match_uuid",
        "result" => "some result",
        "schedule_uuid" => "some schedule_uuid",
        "score_away_team" => 42,
        "score_local_team" => 42,
        "start_date" => "2010-04-17 14:00:00.000000Z",
        "status" => "some status"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, match_path(conn, :create), match: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update match" do
    setup [:create_match]

    test "renders match when data is valid", %{conn: conn, match: %Match{id: id} = match} do
      conn = put conn, match_path(conn, :update, match), match: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, match_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "away_team_uuid" => "some updated away_team_uuid",
        "end_date" => "2011-05-18 15:01:01.000000Z",
        "local_team_uuid" => "some updated local_team_uuid",
        "match_number" => 43,
        "match_uuid" => "some updated match_uuid",
        "result" => "some updated result",
        "schedule_uuid" => "some updated schedule_uuid",
        "score_away_team" => 43,
        "score_local_team" => 43,
        "start_date" => "2011-05-18 15:01:01.000000Z",
        "status" => "some updated status"}
    end

    test "renders errors when data is invalid", %{conn: conn, match: match} do
      conn = put conn, match_path(conn, :update, match), match: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete match" do
    setup [:create_match]

    test "deletes chosen match", %{conn: conn, match: match} do
      conn = delete conn, match_path(conn, :delete, match)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, match_path(conn, :show, match)
      end
    end
  end

  defp create_match(_) do
    match = fixture(:match)
    {:ok, match: match}
  end
end

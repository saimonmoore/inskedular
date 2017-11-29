defmodule InskedularWeb.TeamControllerTest do
  use InskedularWeb.ConnCase

  alias Inskedular.Scheduling
  alias Inskedular.Scheduling.Team

  @create_attrs %{name: "some name", schedule_uuid: "some schedule_uuid"}
  @update_attrs %{name: "some updated name", schedule_uuid: "some updated schedule_uuid"}
  @invalid_attrs %{name: nil, schedule_uuid: nil}

  def fixture(:team) do
    {:ok, team} = Scheduling.create_team(@create_attrs)
    team
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all teams", %{conn: conn} do
      conn = get conn, team_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create team" do
    test "renders team when data is valid", %{conn: conn} do
      conn = post conn, team_path(conn, :create), team: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, team_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "name" => "some name",
        "schedule_uuid" => "some schedule_uuid"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, team_path(conn, :create), team: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update team" do
    setup [:create_team]

    test "renders team when data is valid", %{conn: conn, team: %Team{id: id} = team} do
      conn = put conn, team_path(conn, :update, team), team: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, team_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "name" => "some updated name",
        "schedule_uuid" => "some updated schedule_uuid"}
    end

    test "renders errors when data is invalid", %{conn: conn, team: team} do
      conn = put conn, team_path(conn, :update, team), team: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete team" do
    setup [:create_team]

    test "deletes chosen team", %{conn: conn, team: team} do
      conn = delete conn, team_path(conn, :delete, team)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, team_path(conn, :show, team)
      end
    end
  end

  defp create_team(_) do
    team = fixture(:team)
    {:ok, team: team}
  end
end

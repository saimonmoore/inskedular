defmodule InskedularWeb.MatchController do
  use InskedularWeb, :controller

  alias Inskedular.Scheduling

  action_fallback InskedularWeb.FallbackController

  def index(conn, params) do
    matches = Scheduling.list_matches(params)
    render(conn, "index.json", matches: matches)
  end
end

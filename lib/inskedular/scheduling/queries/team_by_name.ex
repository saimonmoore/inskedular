defmodule Inskedular.Scheduling.Queries.TeamByName do
  import Ecto.Query

  alias Inskedular.Scheduling.Projections.Team

  def new(name) do
    from s in Team,
    where: s.name == ^name
  end
end

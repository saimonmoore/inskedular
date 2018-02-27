defmodule Inskedular.Scheduling.Queries.TeamByName do
  import Ecto.Query

  alias Inskedular.Scheduling.Projections.Team

  def new(name) do
    from t in Team,
    where: t.name == ^name and fragment("? is distinct from 'deleted'", field(t, :status))
  end
end

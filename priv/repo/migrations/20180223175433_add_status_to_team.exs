defmodule Inskedular.Repo.Migrations.AddStatusToTeam do
  use Ecto.Migration

  def change do
    alter table("scheduling_teams", primary_key: false) do
      add :status, :string
    end
  end
end

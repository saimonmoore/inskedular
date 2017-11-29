defmodule Inskedular.Scheduling.Team do
  use Ecto.Schema
  import Ecto.Changeset
  alias Inskedular.Scheduling.Team


  schema "scheduling_teams" do
    field :name, :string
    field :schedule_uuid, :string

    timestamps()
  end

  @doc false
  def changeset(%Team{} = team, attrs) do
    team
    |> cast(attrs, [:name, :schedule_uuid])
    |> validate_required([:name, :schedule_uuid])
  end
end

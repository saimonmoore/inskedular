defmodule Inskedular.Scheduling.Projections.Team do
  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: false}

  schema "scheduling_teams" do
    field :name, :string
    field :schedule_uuid, :string

    timestamps(type: :utc_datetime)
  end
end

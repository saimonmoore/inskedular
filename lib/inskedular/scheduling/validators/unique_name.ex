defmodule Inskedular.Scheduling.Validators.UniqueName do
  use Vex.Validator

  alias Inskedular.Scheduling
  alias Inskedular.Scheduling.Projections.Schedule

  def validate(name, context) do
    schedule_uuid = Map.get(context, :schedule_uuid)
    name_taken = name_taken?(name, schedule_uuid)

    case name_taken do
      true -> {:error, "has already been taken"}
      false -> :ok
    end
  end

  defp name_taken?(name, schedule_uuid) do
    case Scheduling.schedule_by_name(name) do
      %Schedule{uuid: ^schedule_uuid} -> true
      nil -> false
      _ -> false
    end
  end
end

defmodule Inskedular.Support.Validators.Number do
  use Vex.Validator

  def validate(nil, _options), do: :ok
  def validate(value, _options) do
    Vex.Validators.By.validate(value, [function: &Kernel.is_integer/1])
  end
end

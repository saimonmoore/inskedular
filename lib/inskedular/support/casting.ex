defmodule Inskedular.Support.Casting do  
  defmacro __using__(_) do
    quote do
      def cast_datetime(string) when is_nil(string) do
        {:ok, nil}
      end
      def cast_datetime(string) when length(string) <= 0 do
        {:ok, nil}
      end
      def cast_datetime(string) when is_binary(string) do
        case DateTime.from_iso8601(string) do
          {:ok, date, _utc_offset } -> {:ok, date }
          {:error, reason } -> {:error, reason }
        end
      end
    end
  end
end 

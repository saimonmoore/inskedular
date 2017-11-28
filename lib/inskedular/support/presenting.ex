defmodule Inskedular.Support.Presenting do  
  defmacro __using__(_) do
    quote do
      def present_datetime(string) when is_nil(string) do
        "No Date"
      end
      def present_datetime(date_time) do
        %DateTime{day: day, month: month, year: year, hour: hour, minute: minute, second: second} = date_time
        "#{pad_int(day)}-#{pad_int(month)}-#{pad_int(year)} #{pad_int(hour)}:#{pad_int(minute)}:#{pad_int(second)}"
      end

      defp pad_int(integer) do
        integer
        |> to_string
        |> String.pad_leading(2, "0")
      end
    end
  end
end 

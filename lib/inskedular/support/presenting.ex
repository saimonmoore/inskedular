defmodule Inskedular.Support.Presenting do  
  defmacro __using__(_) do
    quote do
      def present_datetime(string) when is_nil(string) do
        "No Date"
      end
      def present_datetime(date_time) do
        %DateTime{day: day, month: month, year: year, hour: hour, minute: minute} = date_time
        "#{day}-#{month}-#{year} #{hour}:#{minute}"
      end
    end
  end
end 

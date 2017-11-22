defmodule InskedularWeb.ScheduleController do
  use InskedularWeb, :controller

  alias Inskedular.Scheduling
  alias Inskedular.Scheduling.Schedule

  action_fallback InskedularWeb.FallbackController

end

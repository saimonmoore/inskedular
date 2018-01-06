defmodule InskedularWeb.LayoutView do
  use InskedularWeb, :view

  def js_script_tag(path) do
    if Application.get_env(:inskedular, :environment) == :production do
      # In production we'll just reference the file
      "<script src=\"/js/#{path}\"></script>"
    else
      # In development mode we'll load it from our webpack dev server
      "<script src=\"http://localhost:8080/js/#{path}\"></script>"
    end
  end

  def css_link_tag(path) do
    if Application.get_env(:inskedular, :environment) == :production do
      "<link rel=\"stylesheet\" type=\"text/css\" href=\"/css/#{path}\" />"
    else
      "<link rel=\"stylesheet\" type=\"text/css\" href=\"http://localhost:8080/css/#{path}\" />"
    end
  end
end

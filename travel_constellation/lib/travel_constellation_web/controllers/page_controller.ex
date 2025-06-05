defmodule TravelConstellationWeb.PageController do
  use TravelConstellationWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end

  def stars(conn, _params) do
    diaries = TravelConstellation.Blog.list_diaries()
    render(conn, :stars, diaries: diaries)
  end
end

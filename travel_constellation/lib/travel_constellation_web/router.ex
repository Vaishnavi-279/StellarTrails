defmodule TravelConstellationWeb.Router do
  use TravelConstellationWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {TravelConstellationWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TravelConstellationWeb do
    pipe_through :browser

    get "/", PageController, :home
    get "/stars", PageController, :stars

    live "/explore", DiaryLive.Explore, :index

    live "/diaries", DiaryLive.Index, :index
    live "/diaries/new", DiaryLive.Index, :new
    live "/diaries/:id/edit", DiaryLive.Index, :edit

    live "/diaries/:id", DiaryLive.Show, :show
    live "/diaries/:id/show/edit", DiaryLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", TravelConstellationWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:travel_constellation, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: TravelConstellationWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end

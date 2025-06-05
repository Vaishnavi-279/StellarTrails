defmodule TravelConstellationWeb.DiaryLive.Show do
  use TravelConstellationWeb, :live_view

  alias TravelConstellation.Blog

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Diary {@diary.id}
        <:subtitle>This is a diary record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/diaries"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/diaries/#{@diary}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit diary
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Title">{@diary.title}</:item>
        <:item title="Content">{@diary.content}</:item>
        <:item title="Location">{@diary.location}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Diary")
     |> assign(:diary, Blog.get_diary!(id))}
  end
end

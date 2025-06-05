defmodule TravelConstellationWeb.DiaryLive.Explore do
  use TravelConstellationWeb, :live_view

  alias TravelConstellation.Blog

  @impl true
  def render(assigns) do
    ~H"""
    <h1 class="text-2xl font-bold mb-4">Explore Travel Diaries</h1>

    <ul class="space-y-4">
      <%= for {_id, diary} <- @streams.diaries do %>
        <li class="p-4 bg-white rounded-xl shadow-md">
          <h2 class="text-xl font-semibold">{diary.title}</h2>
          <p class="text-sm text-gray-600">Location: {diary.location}</p>
          <p class="mt-2 text-gray-800">{String.slice(diary.content, 0, 100)}...</p>
          <.link class="text-blue-600 underline" href={~p"/diaries/#{diary}"}>Read More →</.link>
        </li>
      <% end %>
    </ul>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Explore Diaries")
     |> stream(:diaries, Blog.list_diaries())}
  end
end

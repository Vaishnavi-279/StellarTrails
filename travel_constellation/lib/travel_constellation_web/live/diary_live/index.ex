defmodule TravelConstellationWeb.DiaryLive.Index do
  use TravelConstellationWeb, :live_view

  alias TravelConstellation.Blog

  @impl true

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Listing Diaries (Developer View)
        <:actions>
          <.button variant="primary" patch={~p"/diaries/new"}>
            <.icon name="hero-plus" /> New Diary
          </.button>
        </:actions>
      </.header>

      <%= if @form do %>
        <section>
          <h2 class="text-lg font-bold mb-2">{if @diary, do: "Edit Diary", else: "Add New Diary"}</h2>
          <.form for={@form} phx-submit="save" class="space-y-2">
            <.input field={@form[:title]} label="Title" required />
            <.input field={@form[:content]} label="Content" type="textarea" required />
            <.input field={@form[:location]} label="Location" required />
            <.button type="submit" variant="primary">
              {if @diary, do: "Update Diary", else: "Add Diary"}
            </.button>
          </.form>
        </section>
      <% end %>

      <.table
        id="diaries"
        rows={@streams.diaries}
        row_click={fn {_id, diary} -> JS.navigate(~p"/diaries/#{diary}") end}
      >
        <:col :let={{_id, diary}} label="Title">{diary.title}</:col>
        <:col :let={{_id, diary}} label="Content">{diary.content}</:col>
        <:col :let={{_id, diary}} label="Location">{diary.location}</:col>

        <:action :let={{_id, diary}}>
          <.link patch={~p"/diaries/#{diary}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, diary}}>
          <.link
            phx-click={JS.push("delete", value: %{id: diary.id}) |> hide("##{id}")}
            data-confirm="Are you sure?"
          >
            Delete
          </.link>
        </:action>
      </.table>
    </Layouts.app>
    """
  end

  @impl true

  def mount(_params, _session, socket) do
    changeset = Blog.change_diary(%TravelConstellation.Blog.Diary{})

    {:ok,
     socket
     |> assign(:page_title, "Developer Diary View")
     |> assign(:form, to_form(changeset))
     |> stream(:diaries, Blog.list_diaries())}
  end

  @impl true
  def handle_event("save", %{"diary" => diary_params}, socket) do
    case socket.assigns do
      %{diary: %TravelConstellation.Blog.Diary{} = diary} ->
        case Blog.update_diary(diary, diary_params) do
          {:ok, updated_diary} ->
            changeset = Blog.change_diary(%TravelConstellation.Blog.Diary{})

            {:noreply,
             socket
             |> push_patch(to: ~p"/diaries")
             |> assign(:diary, nil)
             |> assign(:form, to_form(changeset))
             |> stream_insert(:diaries, updated_diary)}

          {:error, changeset} ->
            {:noreply, assign(socket, :form, to_form(changeset))}
        end

      _ ->
        case Blog.create_diary(diary_params) do
          {:ok, new_diary} ->
            changeset = Blog.change_diary(%TravelConstellation.Blog.Diary{})

            {:noreply,
             socket
             |> push_patch(to: ~p"/diaries")
             |> assign(:form, to_form(changeset))
             |> stream_insert(:diaries, new_diary)}

          {:error, changeset} ->
            {:noreply, assign(socket, :form, to_form(changeset))}
        end
    end
  end

  @impl true
  def handle_params(params, _url, socket) do
    case socket.view do
      __MODULE__ ->
        case params do
          %{"id" => id} ->
            diary = Blog.get_diary!(id)
            changeset = Blog.change_diary(diary)

            {:noreply,
             socket
             |> assign(:form, to_form(changeset))
             |> assign(:diary, diary)}

          _ ->
            changeset = Blog.change_diary(%TravelConstellation.Blog.Diary{})

            {:noreply,
             socket
             |> assign(:form, to_form(changeset))
             |> assign(:diary, nil)}
        end
    end
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    diary = Blog.get_diary!(id)
    {:ok, _} = Blog.delete_diary(diary)

    {:noreply, stream_delete(socket, :diaries, diary)}
  end
end

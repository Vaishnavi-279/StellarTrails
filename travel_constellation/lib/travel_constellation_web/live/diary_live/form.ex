defmodule TravelConstellationWeb.DiaryLive.Form do
  use TravelConstellationWeb, :live_view

  alias TravelConstellation.Blog
  alias TravelConstellation.Blog.Diary

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage diary records in your database.</:subtitle>
      </.header>

      <.form for={@form} id="diary-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:content]} type="textarea" label="Content" />
        <.input field={@form[:location]} type="text" label="Location" />
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save Diary</.button>
          <.button navigate={return_path(@return_to, @diary)}>Cancel</.button>
        </footer>
      </.form>
    </Layouts.app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  defp apply_action(socket, :edit, %{"id" => id}) do
    diary = Blog.get_diary!(id)

    socket
    |> assign(:page_title, "Edit Diary")
    |> assign(:diary, diary)
    |> assign(:form, to_form(Blog.change_diary(diary)))
  end

  defp apply_action(socket, :new, _params) do
    diary = %Diary{}

    socket
    |> assign(:page_title, "New Diary")
    |> assign(:diary, diary)
    |> assign(:form, to_form(Blog.change_diary(diary)))
  end

  @impl true
  def handle_event("validate", %{"diary" => diary_params}, socket) do
    changeset = Blog.change_diary(socket.assigns.diary, diary_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"diary" => diary_params}, socket) do
    save_diary(socket, socket.assigns.live_action, diary_params)
  end

  defp save_diary(socket, :edit, diary_params) do
    case Blog.update_diary(socket.assigns.diary, diary_params) do
      {:ok, diary} ->
        {:noreply,
         socket
         |> put_flash(:info, "Diary updated successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, diary))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_diary(socket, :new, diary_params) do
    case Blog.create_diary(diary_params) do
      {:ok, diary} ->
        {:noreply,
         socket
         |> put_flash(:info, "Diary created successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, diary))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path("index", _diary), do: ~p"/diaries"
  defp return_path("show", diary), do: ~p"/diaries/#{diary}"
end

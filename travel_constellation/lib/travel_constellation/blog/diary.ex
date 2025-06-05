defmodule TravelConstellation.Blog.Diary do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :title, :content, :location, :inserted_at, :updated_at]}
  schema "diaries" do
    field :title, :string
    field :content, :string
    field :location, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(diary, attrs) do
    diary
    |> cast(attrs, [:title, :content, :location])
    |> validate_required([:title, :content, :location])
  end
end

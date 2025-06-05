defmodule TravelConstellation.Repo.Migrations.CreateDiaries do
  use Ecto.Migration

  def change do
    create table(:diaries) do
      add :title, :string
      add :content, :text
      add :location, :string

      timestamps(type: :utc_datetime)
    end
  end
end

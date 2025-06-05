defmodule TravelConstellation.BlogFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TravelConstellation.Blog` context.
  """

  @doc """
  Generate a diary.
  """
  def diary_fixture(attrs \\ %{}) do
    {:ok, diary} =
      attrs
      |> Enum.into(%{
        content: "some content",
        location: "some location",
        title: "some title"
      })
      |> TravelConstellation.Blog.create_diary()

    diary
  end
end

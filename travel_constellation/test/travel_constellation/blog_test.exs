defmodule TravelConstellation.BlogTest do
  use TravelConstellation.DataCase

  alias TravelConstellation.Blog

  describe "diaries" do
    alias TravelConstellation.Blog.Diary

    import TravelConstellation.BlogFixtures

    @invalid_attrs %{content: nil, location: nil, title: nil}

    test "list_diaries/0 returns all diaries" do
      diary = diary_fixture()
      assert Blog.list_diaries() == [diary]
    end

    test "get_diary!/1 returns the diary with given id" do
      diary = diary_fixture()
      assert Blog.get_diary!(diary.id) == diary
    end

    test "create_diary/1 with valid data creates a diary" do
      valid_attrs = %{content: "some content", location: "some location", title: "some title"}

      assert {:ok, %Diary{} = diary} = Blog.create_diary(valid_attrs)
      assert diary.content == "some content"
      assert diary.location == "some location"
      assert diary.title == "some title"
    end

    test "create_diary/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Blog.create_diary(@invalid_attrs)
    end

    test "update_diary/2 with valid data updates the diary" do
      diary = diary_fixture()
      update_attrs = %{content: "some updated content", location: "some updated location", title: "some updated title"}

      assert {:ok, %Diary{} = diary} = Blog.update_diary(diary, update_attrs)
      assert diary.content == "some updated content"
      assert diary.location == "some updated location"
      assert diary.title == "some updated title"
    end

    test "update_diary/2 with invalid data returns error changeset" do
      diary = diary_fixture()
      assert {:error, %Ecto.Changeset{}} = Blog.update_diary(diary, @invalid_attrs)
      assert diary == Blog.get_diary!(diary.id)
    end

    test "delete_diary/1 deletes the diary" do
      diary = diary_fixture()
      assert {:ok, %Diary{}} = Blog.delete_diary(diary)
      assert_raise Ecto.NoResultsError, fn -> Blog.get_diary!(diary.id) end
    end

    test "change_diary/1 returns a diary changeset" do
      diary = diary_fixture()
      assert %Ecto.Changeset{} = Blog.change_diary(diary)
    end
  end
end

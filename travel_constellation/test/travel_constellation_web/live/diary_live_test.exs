defmodule TravelConstellationWeb.DiaryLiveTest do
  use TravelConstellationWeb.ConnCase

  import Phoenix.LiveViewTest
  import TravelConstellation.BlogFixtures

  @create_attrs %{content: "some content", location: "some location", title: "some title"}
  @update_attrs %{content: "some updated content", location: "some updated location", title: "some updated title"}
  @invalid_attrs %{content: nil, location: nil, title: nil}
  defp create_diary(_) do
    diary = diary_fixture()

    %{diary: diary}
  end

  describe "Index" do
    setup [:create_diary]

    test "lists all diaries", %{conn: conn, diary: diary} do
      {:ok, _index_live, html} = live(conn, ~p"/diaries")

      assert html =~ "Listing Diaries"
      assert html =~ diary.title
    end

    test "saves new diary", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/diaries")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Diary")
               |> render_click()
               |> follow_redirect(conn, ~p"/diaries/new")

      assert render(form_live) =~ "New Diary"

      assert form_live
             |> form("#diary-form", diary: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#diary-form", diary: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/diaries")

      html = render(index_live)
      assert html =~ "Diary created successfully"
      assert html =~ "some title"
    end

    test "updates diary in listing", %{conn: conn, diary: diary} do
      {:ok, index_live, _html} = live(conn, ~p"/diaries")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#diaries-#{diary.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/diaries/#{diary}/edit")

      assert render(form_live) =~ "Edit Diary"

      assert form_live
             |> form("#diary-form", diary: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#diary-form", diary: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/diaries")

      html = render(index_live)
      assert html =~ "Diary updated successfully"
      assert html =~ "some updated title"
    end

    test "deletes diary in listing", %{conn: conn, diary: diary} do
      {:ok, index_live, _html} = live(conn, ~p"/diaries")

      assert index_live |> element("#diaries-#{diary.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#diaries-#{diary.id}")
    end
  end

  describe "Show" do
    setup [:create_diary]

    test "displays diary", %{conn: conn, diary: diary} do
      {:ok, _show_live, html} = live(conn, ~p"/diaries/#{diary}")

      assert html =~ "Show Diary"
      assert html =~ diary.title
    end

    test "updates diary and returns to show", %{conn: conn, diary: diary} do
      {:ok, show_live, _html} = live(conn, ~p"/diaries/#{diary}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/diaries/#{diary}/edit?return_to=show")

      assert render(form_live) =~ "Edit Diary"

      assert form_live
             |> form("#diary-form", diary: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#diary-form", diary: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/diaries/#{diary}")

      html = render(show_live)
      assert html =~ "Diary updated successfully"
      assert html =~ "some updated title"
    end
  end
end

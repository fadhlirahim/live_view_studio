defmodule LiveViewStudioWeb.VehiclesLiveTest do
  use LiveViewStudioWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "render", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/vehicles")

    assert render(view) =~ "🚙 Vehicles 🚘"
  end

  test "paginates using the options in the URL", %{conn: conn} do
    a = create_vehicle("Tesla A")
    b = create_vehicle("Tesla B")

    {:ok, view, _html} = live(conn, "/vehicles?page=1&per_page=1")

    assert has_element?(view, vehicle_row(a))
    refute has_element?(view, vehicle_row(b))

    {:ok, view, _html} = live(conn, "/vehicles?page=2&per_page=1")

    refute has_element?(view, vehicle_row(a))
    assert has_element?(view, vehicle_row(b))

    {:ok, view, _html} = live(conn, "/vehicles?page=1&per_page=2")

    assert has_element?(view, vehicle_row(a))
    assert has_element?(view, vehicle_row(b))
  end

  test "clicking next, previous, and page links patch the URL", %{conn: conn} do
    _a = create_vehicle("Tesla A")
    _b = create_vehicle("Tesla B")
    _c = create_vehicle("Tesla C")

    {:ok, view, _html} = live(conn, "/vehicles?page=1&per_page=1&sort_by=id&sort_order=asc")

    view
    |> element("a", "Next")
    |> render_click()

    assert_patched(view, "/vehicles?page=2&per_page=1&sort_by=id&sort_order=asc")

    view
    |> element("a", "Previous")
    |> render_click()

    assert_patched(view, "/vehicles?page=1&per_page=1&sort_by=id&sort_order=asc")

    view
    |> element("a", "2")
    |> render_click()

    assert_patched(view, "/vehicles?page=2&per_page=1&sort_by=id&sort_order=asc")
  end

  test "changing the per-page form patches the URL", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/vehicles?page=2")

    view
    |> form("#select-per-page", %{"per-page": 10})
    |> render_change()

    assert_patch(view, "/vehicles?page=2&per_page=10&sort_by=id&sort_order=asc")
  end

  test "initially renders vehicles ordered by id ascending", %{conn: conn} do
    a = create_vehicle("A")
    b = create_vehicle("B")
    c = create_vehicle("C")

    {:ok, view, _html} = live(conn, "/vehicles")

    assert render(view) =~ vehicles_in_order(a, b, c)
  end

  test "sorts using the options in the URL", %{conn: conn} do
    a = create_vehicle("A")
    b = create_vehicle("B")
    c = create_vehicle("C")

    {:ok, view, _html} = live(conn, sort_path("make", "desc"))

    assert render(view) =~ vehicles_in_order(c, b, a)
  end

  test "clicking sorting links patches the URL", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/vehicles")

    view
    |> element("a", "ID")
    |> render_click()

    assert_patched(view, sort_path("id", "desc"))

    view
    |> element("a", "Make")
    |> render_click()

    assert_patched(view, sort_path("make", "asc"))

    view
    |> element("a", "Model")
    |> render_click()

    assert_patched(view, sort_path("model", "desc"))
  end

  defp sort_path(sort_by, sort_order) do
    "/vehicles?" <> "sort_by=#{sort_by}&sort_order=#{sort_order}&page=1&per_page=5"
  end

  defp vehicles_in_order(first, second, third) do
    ~r/#{first.make}.*#{second.make}.*#{third.make}/s
  end

  defp vehicle_row(vehicle), do: "#vehicle-#{vehicle.id}"

  defp create_vehicle(make) do
    {:ok, vehicle} =
      LiveViewStudio.Vehicles.create_vehicle(%{
        color: "Red",
        make: make,
        model: "Plaid"
      })

    vehicle
  end
end

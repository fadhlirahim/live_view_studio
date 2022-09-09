defmodule LiveViewStudioWeb.ServersLiveTest do
  use LiveViewStudioWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "clicking a server link shows its details", %{conn: conn} do
    first = create_server("First")
    second = create_server("Second")

    {:ok, view, _html} = live(conn, "/servers")

    # order by desc id
    assert has_element?(view, "nav", second.name)
    assert has_element?(view, "nav", first.name)
    assert has_element?(view, "#servers", second.name)

    view
    |> element("nav a", first.name)
    |> render_click()

    assert has_element?(view, "#servers", first.name)
    assert_patched(view, "/servers?id=#{first.id}")
  end

  test "selects the server identified in the URL", %{conn: conn} do
    first = create_server("First")
    _second = create_server("Second")

    {:ok, view, _html} = live(conn, "/servers?id=#{first.id}")

    assert has_element?(view, "#servers", first.name)
  end

  test "adds valid server to list", %{conn: conn} do
    _first = create_server("First")

    {:ok, view, _html} = live(conn, "/servers/new")

    valid_attrs = valid_attrs("newt")

    view
    |> form("#create-server", %{server: valid_attrs})
    |> render_submit()

    {:ok, view, _html} = live(conn, "/servers")

    assert has_element?(view, "#servers", valid_attrs.name)
  end

  test "live validation", %{conn: conn} do
    _first = create_server("First")

    {:ok, view, _html} = live(conn, "/servers/new")

    invalid_attrs = %{name: "", size: "", framework: "", git_repo: ""}

    view
    |> form("#create-server", %{server: invalid_attrs})
    |> render_submit()

    assert has_element?(view, "#create-server", "can't be blank")
  end

  test "clicking status button toggles status", %{conn: conn} do
    server = create_server("warp")

    {:ok, view, _html} = live(conn, "/servers")

    status_button = "#server-#{server.id} button"

    view
    |> element(status_button, "down")
    |> render_click()

    assert has_element?(view, status_button, "up")

    view
    |> element(status_button, "up")
    |> render_click()
    assert has_element?(view, status_button, "down")
  end

  test "receives real-time updates", %{conn: conn} do
    _first = create_server("first")

    {:ok, view, _html} = live(conn, "/servers")

    # After creation of server Servers broadcast message to PubSub
    # ServersLive subscribe to Pubsub Servers
    # ServerLive#handle_info will take care of the event
    external_server = create_server("boop")

    assert has_element?(view, "#servers", external_server.name)
  end

  defp valid_attrs(name) do
    %{
      name: name,
      size: 1.0,
      framework: "framework",
      git_repo: "repo"
    }
  end

  defp create_server(name) do
    {:ok, server} =
      LiveViewStudio.Servers.create_server(
        Map.merge(
          valid_attrs(name),
          %{ status: "down",
             deploy_count: 1,
             last_commit_id: "id",
             last_commit_message: "message"}
        )
      )
    server
  end
end

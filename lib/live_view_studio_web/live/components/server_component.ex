defmodule LiveViewStudioWeb.ServerComponent do
  use Phoenix.LiveComponent

  alias LiveViewStudio.Servers

  def render(assigns) do
    ~H"""
    <div id={"server-#{@selected_server.id}"} class="card">
      <div class="header">
        <h2><%= @selected_server.name %></h2>
        <button class={@selected_server.status}
                phx-click="toggle-status"
                phx-debounce="100"
                phx-value-id={@selected_server.id}
                phx-disable-with="Saving..."
                phx-target={@myself}>
          <%= @selected_server.status %>
        </button>
      </div>
      <div class="body">
        <div class="row">
          <div class="deploys">
            <img src="/images/deploy.svg">
            <span>
              <%= @selected_server.deploy_count %> deploys
            </span>
          </div>
          <span>
            <%= @selected_server.size %> MB
          </span>
          <span>
            <%= @selected_server.framework %>
          </span>
        </div>
        <h3>Git Repo</h3>
        <div class="repo">
          <%= @selected_server.git_repo %>
        </div>
        <h3>Last Commit</h3>
        <div class="commit">
          <%= @selected_server.last_commit_id %>
        </div>
        <blockquote>
          <%= @selected_server.last_commit_message %>
        </blockquote>
      </div>
    </div>
    """
  end

  # The handler for the "toggle-status" event no longer needs to
  # update the list of servers since that now happens when handling
  # a broadcast message
  def handle_event("toggle-status", %{"id" => id}, socket) do
    server = Servers.get_server!(id)

    # Update the server's status to the opposite of its current status:
    new_status = if server.status == "up", do: "down", else: "up"

    {:ok, _server} =
      Servers.update_server(server, %{status: new_status})

    {:noreply, socket}
  end

end

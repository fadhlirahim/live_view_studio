defmodule LiveViewStudioWeb.ServersLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Servers

  def mount(_params, _session, socket) do
<<<<<<< HEAD
    if connected?(socket), do: Servers.subscribe()
||||||| d7114a7
    servers = Servers.list_servers()
=======
    if connected?(socket), do: Servers.subscribe()

    servers = Servers.list_servers()
>>>>>>> 24-file-uploads-extra

    servers = Servers.list_servers()

    {:ok, assign(socket, servers: servers)}
  end

  def handle_params(%{"id" => id}, _url, socket) do
    server = Servers.get_server!(String.to_integer(id))

    socket =
      assign(socket,
        selected_server: server,
        page_title: "What's up #{server.name}?"
      )

    {:noreply, socket}
  end

<<<<<<< HEAD
  def handle_params(_params, _url, socket) do
    if socket.assigns.live_action == :new do
      {:noreply, assign(socket, :selected_server, nil)}
    else
      {:noreply, assign(socket, :selected_server, hd(socket.assigns.servers))}
    end
||||||| d7114a7
  def handle_params(_, _url, socket) do
    {:noreply, socket}
=======
  def handle_params(_params, _url, socket) do
    if socket.assigns.live_action == :new do
      socket =
        assign(socket,
          selected_server: nil
        )

      {:noreply, socket}
    else
      # The live_action is NOT "new", so the form
      # is NOT being displayed. Therefore, don't assign
      # an empty changeset. Instead, just select the
      # first server in list. This previously happened
      # in "mount", but since "handle_params" is always
      # invoked after "mount", we decided to select the
      # default server here instead of in "mount".

      socket =
        assign(socket,
          selected_server: hd(socket.assigns.servers)
        )

      {:noreply, socket}
    end
  end

  # New function to handle a broadcast message indicating
  # that a server has been created.
  def handle_info({:server_created, server}, socket) do
    socket =
      update(
        socket,
        :servers,
        fn servers -> [server | servers] end
      )

    {:noreply, socket}
>>>>>>> 24-file-uploads-extra
  end

<<<<<<< HEAD
  def render(assigns) do
    ~L"""
    <h1>Servers</h1>
    <div id="servers">
      <div class="sidebar">
        <nav>
          <%= live_patch "New Server",
                to: Routes.servers_path(@socket, :new),
                class: "button" %>
          <%= for server <- @servers do %>
            <%= live_patch link_body(server),
                  to: Routes.live_path(
                    @socket,
                    __MODULE__,
                    id: server.id
                  ),
                  class: (if server == @selected_server, do: "active") %>
          <% end %>
        </nav>
      </div>
      <div class="main">
        <div class="wrapper">
          <%= if @live_action == :new do %>
            <%= live_modal @socket,
                    LiveViewStudioWeb.ServerFormComponent,
                    id: :new,
                    title: "Add New Server",
                    return_to: Routes.live_path(@socket, __MODULE__) %>
          <% else %>
            <%= live_component @socket, LiveViewStudioWeb.ServerComponent,
                             id: @selected_server.id,
                             selected_server: @selected_server %>
          <% end %>
        </div>
      </div>
    </div>
    """
||||||| d7114a7
  def render(assigns) do
    ~L"""
    <h1>Servers</h1>
    <div id="servers">
      <div class="sidebar">
        <nav>
          <%= for server <- @servers do %>
            <div>
              <%= live_patch link_body(server),
                    to: Routes.live_path(
                              @socket,
                              __MODULE__,
                              id: server.id
                        ),
                    class: if server == @selected_server, do: "active" %>
            </div>

          <% end %>
        </nav>
      </div>
      <div class="main" id="selected-server">
        <div class="wrapper">
          <div class="card">
            <div class="header">
              <h2><%= @selected_server.name %></h2>
              <span class="<%= @selected_server.status %>">
                <%= @selected_server.status %>
              </span>
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
        </div>
      </div>
    </div>
    """
=======
  # New function to handle a broadcast message indicating
  # that a server has been updated.
  def handle_info({:server_updated, server}, socket) do

    # If the updated server is the selected server,
    # assign it so the button is re-rendered with
    # the correct status text.
    socket =
      if server.id == socket.assigns.selected_server.id do
        assign(socket, selected_server: server)
      else
        socket
      end

    # Refetch the list of servers so the status indicators
    # in the sidebar are updated:

    servers = Servers.list_servers()
    socket = assign(socket, servers: servers)

    # Or find the matching server in the current list of
    # servers, change it, and update the list of servers:

    socket =
      update(socket, :servers, fn servers ->
        for s <- servers do
          case s.id == server.id do
            true -> server
            _ -> s
          end
        end
      end)

    {:noreply, socket}
>>>>>>> 24-file-uploads-extra
  end

  def handle_info({:server_created, server}, socket) do
    socket =
      update(
        socket,
        :servers,
        fn servers -> [server | servers] end
      )

    {:noreply, socket}
  end

  def handle_info({:server_updated, server}, socket) do
    socket =
      if server.id == socket.assigns.selected_server.id do
        assign(socket, selected_server: server)
      else
        socket
      end

    # Find the matching server in the current list of
    # servers, change it, and update the list of servers:

    socket =
      update(socket, :servers, fn servers ->
        for s <- servers do
          case s.id == server.id do
            true -> server
            _ -> s
          end
        end
      end)

    {:noreply, socket}
  end

  defp link_body(server) do
    assigns = %{name: server.name, status: server.status}

    ~L"""
    <span class="status <%= @status %>"></span>
    <img src="/images/server.svg">
    <%= @name %>
    """
  end
end

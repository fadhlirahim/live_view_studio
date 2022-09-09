defmodule LiveViewStudioWeb.ServersLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Servers

  def mount(_params, _session, socket) do
    if connected?(socket), do: Servers.subscribe()

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

  def handle_params(_params, _url, socket) do
    if socket.assigns.live_action == :new do
      {:noreply, assign(socket, :selected_server, nil)}
    else
      {:noreply, assign(socket, :selected_server, hd(socket.assigns.servers))}
    end
  end

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

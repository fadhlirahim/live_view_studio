defmodule LiveViewStudioWeb.ServersLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Servers

  def mount(_params, _session, socket) do
    if connected?(socket), do: Servers.subscribe()

    servers = Servers.list_servers()

    socket =
      assign(socket,
        servers: servers,
        selected_server: hd(servers)
      )

    {:ok, socket}
  end

  def handle_params(%{"id" => id}, _url, socket) do
    id = String.to_integer(id)

    server = Servers.get_server!(id)

    socket =
      assign(socket,
        selected_server: server,
        page_title: "What's up #{server.name}?"
      )

    {:noreply, socket}
  end

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
  end

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

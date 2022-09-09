defmodule LiveViewStudioWeb.ServerFormComponent do
  use LiveViewStudioWeb, :live_component

  alias LiveViewStudio.Servers.Server
  alias LiveViewStudio.Servers

  def mount(socket) do
    changeset = Servers.change_server(%Server{})

    {:ok, assign(socket, changeset: changeset)}
  end

  def render(assigns) do
    ~H"""
    <div>
    <.form let={f} for={@changeset} url="#"
              id="create-server"
              phx-submit="save"
              phx-change="validate"
              phx-target={@myself}>

      <div class="field">
        <%= label f, :name %>
        <%= text_input f, :name,
                      placeholder: "Name",
                      autocomplete: "off",
                      phx_debounce: "blur" %>
        <%= error_tag f, :name %>
      </div>

      <div class="field">
        <%= label f, :framework %>
        <%= text_input f, :framework,
                      placeholder: "Framework",
                      autocomplete: "off",
                      phx_debounce: "blur" %>
        <%= error_tag f, :framework %>
      </div>

      <div class="field">
        <%= label f, :size, "Size (MB)" %>
        <%= number_input f, :size,
                      placeholder: "Size (MB)",
                      autocomplete: "off",
                      phx_debounce: "blur" %>
        <%= error_tag f, :size %>
      </div>

      <div class="field">
        <%= label f, :git_repo %>
        <%= text_input f, :git_repo,
                      placeholder: "Git Repo",
                      autocomplete: "off",
                      phx_debounce: "blur" %>
        <%= error_tag f, :git_repo %>
      </div>

      <%= submit "Save", phx_disable_with: "Saving..." %>

      <%= live_patch "Cancel",
          to: @return_to,
          class: "cancel" %>
    </.form>
    </div>
    """
  end

  # The handler for the "save" event no longer needs to
  # prepend the new server to the list since that now
  # happens when handling a broadcast message.
  def handle_event("save", %{"server" => params}, socket) do
    case Servers.create_server(params) do
      {:ok, server} ->
        # Navigate to the new server's detail page.
        # Invokes handle_params which already gets the
        # server and sets it as the selected server.
        socket =
          push_patch(socket,
            to:
              socket.assigns.return_to
              # Routes.live_path(
              #   socket,
              #   LiveViewStudioWeb.ServersLive,
              #   id: server.id
              # )
          )


        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        socket = assign(socket, changeset: changeset)
        {:noreply, socket}
    end
  end

  def handle_event("validate", %{"server" => params}, socket) do
    changeset =
      %Server{}
      |> Servers.change_server(params)
      |> Map.put(:action, :insert)

    socket = assign(socket, changeset: changeset)

    {:noreply, socket}
  end
end

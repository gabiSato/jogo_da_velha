defmodule JogoDaVelhaWeb.GameLive do
  use JogoDaVelhaWeb, :live_view

  def render(assigns) do
    ~L"""
      <div id="hash-game">
        <h3>Player: <%= @state.current %></h3>
        <div class="game-container">
          <%= for {value, index} <- Enum.with_index(@state.grids) do %>
            <div
              phx-value-index="<%= index %>"
              <%= if !!value || @state.winner do %>
                class="disabled-grid"
              <% else %>
                phx-click="add-value"
              <% end %>
            >
              <%= if value == :circle do %>
                <img src="images/circle.svg">
              <% end %>

              <%= if value == :cross do %>
                <img src="images/cross.svg">
              <% end %>
            </div>
          <% end %>
        </div>
      </div>
    """
  end

  def handle_params(%{"room" => room} = _params, _uri, socket) do
    :ok = Phoenix.PubSub.subscribe(JogoDaVelha.PubSub, room)

    {:noreply, assign_game(socket, room)}
  end

  def handle_event("add-value", %{"index" => index}, socket) do
    %{assigns: %{room: room}} = socket

    parsed_index = String.to_integer(index)

    :ok = GenServer.cast(via_tuple(room), {:add_value, parsed_index})

    :ok = Phoenix.PubSub.broadcast(JogoDaVelha.PubSub, room, :update)

    {:noreply, assign_game(socket)}
  end

  def handle_info(:update, socket) do
    {:noreply, assign_game(socket)}
  end

  defp via_tuple(room) do
    {:via, Registry, {JogoDaVelha.GameRegistry, room}}
  end

  defp assign_game(socket, room) do
    socket
    |> assign(room: room)
    |> assign_game()
  end

  defp assign_game(%{assigns: %{room: room}} = socket) do
    state = GenServer.call(via_tuple(room), :state)

    assign(socket, state: state)
  end

end

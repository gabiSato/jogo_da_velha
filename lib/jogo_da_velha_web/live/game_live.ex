defmodule JogoDaVelhaWeb.GameLive do
  use JogoDaVelhaWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        round: 1,
        player: 1,
        winner: false,
        grids: Map.new(1..9, fn key -> {key, nil} end)
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
      <div id="hash-game">
        <h3>Player: <%= @player %></h3>
        <div class="game-container">
          <%= for {key, value} <- @grids do %>
            <div
              phx-value-index="<%= key %>"
              <%= if !!value || @winner do %>
                class="disabled-grid"
              <% else %>
                phx-click="add-value"
              <% end %>
            >
              <%= if value == 0 do %>
                <img src="images/circle.svg">
              <% end %>

              <%= if value == 1 do %>
                <img src="images/cross.svg">
              <% end %>
            </div>
          <% end %>
        </div>
      </div>
    """
  end

  def handle_event("add-value", %{"index" => index}, socket) do
    %{assigns: %{player: player, grids: grids, round: round}} = socket

    parsedIndex = String.to_integer(index)

    grids = Map.update!(grids, parsedIndex, fn _ -> player - 1 end)

    socket =
      assign(socket,
        grids: grids,
        player: change_player(player),
        winner: validate(grids),
        round: round + 1
      )

    {:noreply, socket}
  end

  defp change_player(player) do
    case player do
      1 -> 2
      2 -> 1
    end
  end

  defp validate(grids) do
    horizontal =
      Enum.reduce([1, 4, 7], false, fn i, acc -> validate_horizontal(grids, i) || acc end)

    vertical = Enum.reduce([1, 2, 3], false, fn i, acc -> validate_vertical(grids, i) || acc end)
    diagonal = Enum.reduce([1, 3], false, fn i, acc -> validate_diagonal(grids, i) || acc end)

    horizontal || vertical || diagonal
  end

  defp validate_diagonal(grids, index) do
    v = if index == 1, do: 1, else: -1

    if !!grids[index] || !!grids[index + v + 3] || !!grids[index + 2 * v + 6],
      do:
        grids[index] == grids[index + v + 3] && grids[index + v + 3] == grids[index + 2 * v + 6],
      else: false
  end

  defp validate_vertical(grids, index) do
    if !!grids[index] || !!grids[index + 3] || !!grids[index + 6],
      do: grids[index] == grids[index + 3] && grids[index + 3] == grids[index + 6],
      else: false
  end

  defp validate_horizontal(grids, index) do
    if !!grids[index] || !!grids[index + 1] || !!grids[index + 2],
      do: grids[index] == grids[index + 1] && grids[index + 1] == grids[index + 2],
      else: false
  end
end

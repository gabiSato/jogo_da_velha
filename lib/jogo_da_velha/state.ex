defmodule JogoDaVelha.State  do

alias JogoDaVelha.State

use GenServer, restart: :transient

defstruct grids: Enum.map(1..9, fn _ -> nil end),
          current: :circle,
          winner: false,
          game_round: 1,
          message: nil

  def start_link(options) do
    GenServer.start_link(__MODULE__, %State{}, options)
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call(:state, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_cast({:add_value, grids}, state) do
    {:noreply, State.add_value(state, grids)}
  end

  @impl true
  def handle_info(:timeout, game) do
    {:stop, :normal, game}
  end

  def add_value(%State{grids: grids, current: current, game_round: game_round} = state, index) do
    new_current = next(current)

    new_grids = List.replace_at(grids, index, current)

    case {validate(new_grids, current), game_round} do
      {false, 9} ->
        %{
          state |
          grids: new_grids,
          winner: false,
          message: "Nenhum jogador ganhou!"
        }

      {false, _} ->
        %{
          state |
          grids: new_grids,
          current: new_current,
          winner: false,
          game_round: game_round + 1
        }

      {_, _} ->
        %{
          state |
          grids: new_grids,
          winner: true,
          game_round: game_round + 1,
          message: "Jogador #{current} ganhou!"
        }

    end
  end

  defp validate(grids, current) do
    win_values = ["123", "456", "789", "147", "258", "369", "159", "357"]

    Enum.with_index(grids, 1)
      |> Enum.filter(fn {v, _k} -> v == current end)
      |> Enum.map_join(fn {_v, k} -> k end)
      |> String.contains?(win_values)
  end

  defp next(:circle), do: :cross
  defp next(:cross), do: :circle
end

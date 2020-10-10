defmodule JogoDaVelhaWeb.LandingLive do
  use JogoDaVelhaWeb, :live_view

  def render(assigns) do
    ~L"""
    <div id="landing">
      <span class="landing-title">Jogo da Velha</span>
      <button class="landing-button" phx-click="play">Jogue agora</button>
    </div>
    """
  end

  def handle_event("play", _, socket) do
    room =
      0..9
      |> Enum.take_random(6)
      |> Enum.join

    name = {:via, Registry, {JogoDaVelha.GameRegistry, room}}

    {:ok, _pid} =
      DynamicSupervisor.start_child(JogoDaVelha.GameSupervisor, {JogoDaVelha.State, name: name})

    socket =
     redirect(
       socket,
       to: JogoDaVelhaWeb.Router.Helpers.live_path(socket, JogoDaVelhaWeb.GameLive, room: room)
     )

    {:noreply, socket}
  end

end

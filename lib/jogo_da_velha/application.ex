defmodule JogoDaVelha.Application do

  use Application

  def start(_type, _args) do
    children = [
      JogoDaVelhaWeb.Endpoint,
      {Registry, keys: :unique, name: JogoDaVelha.GameRegistry},
      {DynamicSupervisor, strategy: :one_for_one, name: JogoDaVelha.GameSupervisor}
    ]

    opts = [strategy: :one_for_one, name: JogoDaVelha.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    JogoDaVelhaWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

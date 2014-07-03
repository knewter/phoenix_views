defmodule PhoenixViews do
  use Application
  alias PhoenixViews.ShellServer

  # See http://elixir-lang.org/docs/stable/Application.Behaviour.html
  # for more information on OTP Applications
  def start(_type, _args) do
    {:ok, pid} = ShellServer.start_link
    Process.register(pid, :shell)
    PhoenixViews.Supervisor.start_link
  end
end

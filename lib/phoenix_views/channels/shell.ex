defmodule PhoenixViews.Channels.Shell do
  use Phoenix.Channel
  alias PhoenixViews.ShellServer

  @doc """
  Authorize socket to subscribe and broadcast events on this channel & topic

  Possible Return Values

  {:ok, socket} to authorize subscription for channel for requested topic

  {:error, socket, reason} to deny subscription/broadcast on this channel
  for the requested topic
  """
  def join(socket, "shell", _message) do
    IO.puts "JOIN #{socket.channel}:#{socket.topic}"
    reply socket, "join", %{status: "connected"}
    broadcast socket, "shell:connected", %{data: "connected"}
    {:ok, socket}
  end

  def join(socket, _private_topic, _message) do
    {:error, socket, :unauthorized}
  end

  def event(socket, "shell:stdin", message) do
    ShellServer.eval(:shell, message["data"])
    socket
  end
end



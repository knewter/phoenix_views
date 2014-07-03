defmodule PhoenixViews.Router do
  use Phoenix.Router
  use Phoenix.Router.Socket, mount: "/ws"

  plug Plug.Static, at: "/static", from: :phoenix_views
  get "/", PhoenixViews.Controllers.Pages, :index, as: :page

  channel "shell", PhoenixViews.Channels.Shell
end

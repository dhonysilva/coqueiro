defmodule CoqueiroWeb.PageController do
  use CoqueiroWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end

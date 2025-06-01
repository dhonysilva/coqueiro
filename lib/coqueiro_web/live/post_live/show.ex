defmodule CoqueiroWeb.PostLive.Show do
  use CoqueiroWeb, :live_view

  alias Coqueiro.Blog

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <pre><%= inspect assigns.current_scope, pretty: true  %></pre>
      <.header>
        Post {@post.id}
        <:subtitle>This is a post record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/orgs/#{@current_scope.organization}/posts"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button
            variant="primary"
            navigate={~p"/orgs/#{@current_scope.organization}/posts/#{@post}/edit?return_to=show"}
          >
            <.icon name="hero-pencil-square" /> Edit post
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Title">{@post.title}</:item>
        <:item title="Body">{@post.body}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    if connected?(socket) do
      Blog.subscribe_posts(socket.assigns.current_scope)
    end

    {:ok,
     socket
     |> assign(:page_title, "Show Post")
     |> assign(:post, Blog.get_post!(socket.assigns.current_scope, id))}
  end

  @impl true
  def handle_info(
        {:updated, %Coqueiro.Blog.Post{id: id} = post},
        %{assigns: %{post: %{id: id}}} = socket
      ) do
    {:noreply, assign(socket, :post, post)}
  end

  def handle_info(
        {:deleted, %Coqueiro.Blog.Post{id: id}},
        %{assigns: %{post: %{id: id}}} = socket
      ) do
    {:noreply,
     socket
     |> put_flash(:error, "The current post was deleted.")
     |> push_navigate(to: ~p"/orgs/#{socket.assigns.current_scope.organization}/posts")}
  end

  def handle_info({type, %Coqueiro.Blog.Post{}}, socket)
      when type in [:created, :updated, :deleted] do
    {:noreply, socket}
  end
end

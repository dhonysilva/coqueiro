defmodule CoqueiroWeb.OrganizationLive.Index do
  use CoqueiroWeb, :live_view

  alias Coqueiro.Accounts

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <pre><%= inspect assigns.current_scope, pretty: true  %></pre>
      <.header>
        Listing Organizations
        <:actions>
          <.button variant="primary" navigate={~p"/orgs/new"}>
            <.icon name="hero-plus" /> New Organization
          </.button>
        </:actions>
      </.header>

      <.table
        id="organizations"
        rows={@streams.organizations}
        row_click={fn {_id, organization} -> JS.navigate(~p"/orgs/#{organization}") end}
      >
        <:col :let={{_id, organization}} label="Name">{organization.name}</:col>
        <:col :let={{_id, organization}} label="Slug">{organization.slug}</:col>
        <:col :let={{_id, organization}} label="Active">{organization.active}</:col>
        <:action :let={{_id, organization}}>
          <div class="sr-only">
            <.link navigate={~p"/orgs/#{organization}"}>Show</.link>
          </div>
          <.link navigate={~p"/orgs/#{organization}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, organization}}>
          <.link
            phx-click={JS.push("delete", value: %{id: organization.id}) |> hide("##{id}")}
            data-confirm="Are you sure?"
          >
            Delete
          </.link>
        </:action>
      </.table>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Accounts.subscribe_organizations(socket.assigns.current_scope)
    end

    {:ok,
     socket
     |> assign(:page_title, "Listing Organizations")
     |> stream(:organizations, Accounts.list_organizations(socket.assigns.current_scope))}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    organization = Accounts.get_organization!(socket.assigns.current_scope, id)
    {:ok, _} = Accounts.delete_organization(socket.assigns.current_scope, organization)

    {:noreply, stream_delete(socket, :organizations, organization)}
  end

  @impl true
  def handle_info({type, %Coqueiro.Accounts.Organization{}}, socket)
      when type in [:created, :updated, :deleted] do
    {:noreply,
     stream(socket, :organizations, Accounts.list_organizations(socket.assigns.current_scope),
       reset: true
     )}
  end
end

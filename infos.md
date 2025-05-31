# Annotations while lerning about Scopes feature

We can obtain the list of Posts under the specified Scope on the IEx terminal:

```elixir
iex> alias Coqueiro.Scope

iex> Coqueiro.Blog.list_posts(Scope.for_id(-576460752303420734))
```

All related Posts are listed.

```elixir
[
  %Coqueiro.Blog.Post{
    __meta__: #Ecto.Schema.Metadata<:loaded, "posts">,
    id: 1,
    title: "Arroz com Feijão",
    session_id: -576460752303420734,
    inserted_at: ~U[2025-05-31 17:28:51Z],
    updated_at: ~U[2025-05-31 17:28:51Z]
  },
  %Coqueiro.Blog.Post{
    __meta__: #Ecto.Schema.Metadata<:loaded, "posts">,
    id: 2,
    title: "Bola",
    session_id: -576460752303420734,
    inserted_at: ~U[2025-05-31 17:48:59Z],
    updated_at: ~U[2025-05-31 17:48:59Z]
  }
]
```

Notice the `Blog.list_posts/1` function, defined to receive the `%Scope{}` struct as its first parameter:

```elixir
# blog.ex
def list_posts(%Scope{} = scope) do
  Repo.all(from post in Post, where: post.session_id == ^scope.id)
end
```

What is happening here while passing the parameter?

```elixir
%Scope{} = scope
```

This is a _pattern matching_ in function parameters in Elixir. `%Scope{} = scope` means:

- The function `list_posts/1` expects the argument to be a `map/struct` of type `Scope`.
- If the argument is not a `%Scope{}` struct, the function will fail to match and not execute.

The `= scope` part means:

- The matched `%Scope{}` struct in then bound to the variable `scope`, so we can use it inside the function body. For example, the `scope.id` on our where clause.

This is equivalent to writing:

```elixir
def list_posts(scope) when is_struct(scope, Scope) do
  ...
end
```

But using the `%Scope{} = scope` syntax is more idiomatic and expressive when we expect specifically a `Scope` struct.

We could also pattern matching keys directly, like:

```elixir
def list_posts(%Scope{id: id}) do
  Repo.all(from post in Post, where: post.session_id == ^id)
end
```

### Step by step on IEx

Here is the a sequence of instructions to use the functions and list all Posts under a specific Scope:

```elixir
iex> alias Coqueiro.Scope
iex> alias Coqueiro.Blob

iex> scope = Scope.for_id(-576460752303420734)

iex> scope
%Coqueiro.Scope{id: -576460752303420734}

iex> Blog.list_posts(scope)
```

We obtain all the Posts under the `session_id` defined on Scope:

```elixir
[
  %Coqueiro.Blog.Post{
    __meta__: #Ecto.Schema.Metadata<:loaded, "posts">,
    id: 1,
    title: "Arroz com Feijão",
    session_id: -576460752303420734,
    inserted_at: ~U[2025-05-31 17:28:51Z],
    updated_at: ~U[2025-05-31 17:28:51Z]
  },
  %Coqueiro.Blog.Post{
    __meta__: #Ecto.Schema.Metadata<:loaded, "posts">,
    id: 2,
    title: "Bola",
    session_id: -576460752303420734,
    inserted_at: ~U[2025-05-31 17:48:59Z],
    updated_at: ~U[2025-05-31 17:48:59Z]
  }
]
```

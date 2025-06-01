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

## Part 2 - Augumenting Scopes

After generating the User Auth through phx.gen.auth, we have the Accounts.Scope file where we have the for_use function:

```elixir
# scope.ex
def for_user(%User{} = user) do
  %__MODULE__{user: user}
end
```

Once I register a user with id = 1,

```elixir
iex> alias Coqueiro.Repo
iex> alias Coqueiro.Accounts.User
iex> user = Repo.get_by!(User, id: 1)
```

It obtains the %User{} struct and store it on user variable.

```elixir
#Coqueiro.Accounts.User<
  __meta__: #Ecto.Schema.Metadata<:loaded, "users">,
  id: 1,
  email: "dhony@gmail.com",
  confirmed_at: ~U[2025-05-31 20:05:35Z],
  authenticated_at: nil,
  inserted_at: ~U[2025-05-31 20:05:29Z],
  updated_at: ~U[2025-05-31 20:05:35Z],
  ...
>
```

Now we can pass the `user` variable to the `for_user` function.

```elixir
iex> scope = Scope.for_user(user)
```

Where we obtain the %Scope{} struct:

```elixir
%Coqueiro.Accounts.Scope{
  user: #Coqueiro.Accounts.User<
    __meta__: #Ecto.Schema.Metadata<:loaded, "users">,
    id: 1,
    email: "dhony@gmail.com",
    confirmed_at: ~U[2025-05-31 20:05:35Z],
    authenticated_at: nil,
    inserted_at: ~U[2025-05-31 20:05:29Z],
    updated_at: ~U[2025-05-31 20:05:35Z],
    ...
  >
}
```

With that, I can destruct some key items.

```elixir
iex> scope.user
#Coqueiro.Accounts.User<
  __meta__: #Ecto.Schema.Metadata<:loaded, "users">,
  id: 1,
  email: "dhony@gmail.com",
  confirmed_at: ~U[2025-05-31 20:05:35Z],
  authenticated_at: nil,
  inserted_at: ~U[2025-05-31 20:05:29Z],
  updated_at: ~U[2025-05-31 20:05:35Z],
  ...
>
```

```elixir
iex> scope.user.email
"dhony@gmail.com"
```

```elixir
iex> scope.user.confirmed_at
~U[2025-05-31 20:05:35Z]
```

Testing the `OrganizationMembership`.

SQL statement to associate the user 1 with the organization 01:

```sql
insert into organization_memberships(user_id, organization_id, inserted_at, updated_at)
values(1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
```

```
sqlite> select * from organization_memberships;
id  user_id  organization_id  inserted_at          updated_at
--  -------  ---------------  -------------------  -------------------
1   1        1                2025-06-01 15:16:28  2025-06-01 15:16:28
```

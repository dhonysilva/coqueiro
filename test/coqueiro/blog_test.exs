defmodule Coqueiro.BlogTest do
  use Coqueiro.DataCase

  alias Coqueiro.Blog

  describe "posts" do
    alias Coqueiro.Blog.Post

    import nil, only: [session_scope_fixture: 0]
    import Coqueiro.BlogFixtures

    @invalid_attrs %{title: nil}

    test "list_posts/1 returns all scoped posts" do
      scope = session_scope_fixture()
      other_scope = session_scope_fixture()
      post = post_fixture(scope)
      other_post = post_fixture(other_scope)
      assert Blog.list_posts(scope) == [post]
      assert Blog.list_posts(other_scope) == [other_post]
    end

    test "get_post!/2 returns the post with given id" do
      scope = session_scope_fixture()
      post = post_fixture(scope)
      other_scope = session_scope_fixture()
      assert Blog.get_post!(scope, post.id) == post
      assert_raise Ecto.NoResultsError, fn -> Blog.get_post!(other_scope, post.id) end
    end

    test "create_post/2 with valid data creates a post" do
      valid_attrs = %{title: "some title"}
      scope = session_scope_fixture()

      assert {:ok, %Post{} = post} = Blog.create_post(scope, valid_attrs)
      assert post.title == "some title"
      assert post.session_id == scope.id
    end

    test "create_post/2 with invalid data returns error changeset" do
      scope = session_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Blog.create_post(scope, @invalid_attrs)
    end

    test "update_post/3 with valid data updates the post" do
      scope = session_scope_fixture()
      post = post_fixture(scope)
      update_attrs = %{title: "some updated title"}

      assert {:ok, %Post{} = post} = Blog.update_post(scope, post, update_attrs)
      assert post.title == "some updated title"
    end

    test "update_post/3 with invalid scope raises" do
      scope = session_scope_fixture()
      other_scope = session_scope_fixture()
      post = post_fixture(scope)

      assert_raise MatchError, fn ->
        Blog.update_post(other_scope, post, %{})
      end
    end

    test "update_post/3 with invalid data returns error changeset" do
      scope = session_scope_fixture()
      post = post_fixture(scope)
      assert {:error, %Ecto.Changeset{}} = Blog.update_post(scope, post, @invalid_attrs)
      assert post == Blog.get_post!(scope, post.id)
    end

    test "delete_post/2 deletes the post" do
      scope = session_scope_fixture()
      post = post_fixture(scope)
      assert {:ok, %Post{}} = Blog.delete_post(scope, post)
      assert_raise Ecto.NoResultsError, fn -> Blog.get_post!(scope, post.id) end
    end

    test "delete_post/2 with invalid scope raises" do
      scope = session_scope_fixture()
      other_scope = session_scope_fixture()
      post = post_fixture(scope)
      assert_raise MatchError, fn -> Blog.delete_post(other_scope, post) end
    end

    test "change_post/2 returns a post changeset" do
      scope = session_scope_fixture()
      post = post_fixture(scope)
      assert %Ecto.Changeset{} = Blog.change_post(scope, post)
    end
  end
end

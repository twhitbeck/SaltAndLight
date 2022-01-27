defmodule Cup.Accounts do

  import Ecto.Query

@moduledoc """
The Accounts context.
"""
alias Cup.Repo
alias Cup.Accounts.Member

  def list_members do
    Repo.all(Member)
  end

  def get_member(id) do
    Repo.get(Member, id)
  end

  # Raise an Ecto.NotFoundError if member doesn't exist
  def get_member!(id) do
    Repo.get!(Member, id)
  end

  def get_member_by(params) do
    Repo.get_by(Member, params)
  end

  def get_member_by_email(email) do
    from(u in Member, join: c in assoc(u, :credential), where: c.email == ^email)
    |> Repo.one()
    |> Repo.preload(:credential)
  end

  def change_member(%Member{} = member) do
    Member.changeset(member, %{})
  end

  def create_member(attrs \\ %{}) do
    %Member{}
    |> Member.changeset(attrs)
    |> Repo.insert()
  end

  def change_registration(%Member{} = member, params) do
    Member.registration_changeset(member, params)
  end

  def register_member(attrs \\ %{}) do
    %Member{}
    |> Member.registration_changeset(attrs)
    |> Repo.insert()
  end

  def authenticate_by_membername_and_pass(membername, given_pass) do
    member = get_member_by(membername: membername)

    cond do
      member && Pbkdf2.verify_pass(given_pass, member.password_hash) ->
        {:ok, member}
      member ->
        {:error, :unauthorized}
    true ->
        Pbkdf2.no_member_verify()
        {:error, :not_found}
    end
  end

  def authenticate_by_email_and_pass(email, given_pass) do
    member = get_member_by_email(email)

    cond do
      member && Comeonin.Pbkdf2.checkpw(given_pass, member.credential.password_hash) ->
        {:ok, member}
      member ->
        {:error, :unauthorized}
      true ->
        Comeonin.Bcrypt.dummy_checkpw()
        {:error, :not_found}
    end
  end

end

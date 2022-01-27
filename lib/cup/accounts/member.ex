defmodule Cup.Accounts.Member do

  use Ecto.Schema
  import Ecto.Changeset
  alias Cup.Accounts.Member

  schema "members" do
    field :title,         :string
    field :lastname,      :string
    field :firstname,     :string
    field :spousename,    :string
    field :streetaddress, :string
    field :city,          :string
    field :state,         :string
    field :zipcode,       :string
    field :phoneone,      :string
    field :phonetwo,      :string
    field :currentmenber, :string
    field :membername,    :string
    field :password,      :string, virtual: true
    field :password_hash, :string
    timestamps()
  end

  def changeset(member, attrs) do
    member
    |> cast(attrs, [:firstname,:lastname, :membername])
    |> validate_required([:firstname,:lastname, :membername])
    |> validate_length(:membername, min: 1, max: 20)
  end

  def registration_changeset(member, params) do
    member
    |> changeset(params)
    |> cast(params, [:password])
    |> validate_required([:password])
    |> validate_length(:password, min: 6, max: 100)
    |> put_pass_hash()
  end

  def change_registration(%Member{} = member, params) do
    Member.registration_changeset(member, params)
  end

  def register_member(attrs \\ %{}) do
    %Member{}
    |> Member.registration_changeset(attrs)
    |> Repo.insert()
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
      put_change(changeset, :password_hash, Pbkdf2.hash_pwd_salt(pass))
    _ ->
      changeset
    end
  end

end

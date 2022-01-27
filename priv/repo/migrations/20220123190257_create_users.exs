defmodule Cup.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
      create table(:families) do
      add :title,         :string
      add :lastname,      :string
      add :firstname,     :string
      add :spousename,    :string
      add :streetaddress, :string
      add :city,          :string
      add :state,         :string
      add :zipcode,       :string
      add :phoneone,      :string
      add :phonetwo,      :string
      add :currentmenber, :string
      add :membername,    :string
      add :password_hash, :string
      timestamps()
    end
    create unique_index(:families, [:username])
  end
end

defmodule UrlshortnerApi.Repo.Migrations.CreateSlugs do
  use Ecto.Migration

  def change do
    create table(:slugs, primary_key: false) do
      add :slug, :string, primary_key: true
      add :is_used, :boolean, default: false, null: false

      timestamps()
    end
  end
end

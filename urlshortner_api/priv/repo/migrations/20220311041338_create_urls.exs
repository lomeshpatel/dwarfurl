defmodule UrlshortnerApi.Repo.Migrations.CreateUrls do
  use Ecto.Migration

  def change do
    create table(:urls, primary_key: false) do
      add :slug, :string, primary_key: true
      add :original_url, :string, size: 65536

      timestamps()
    end
  end
end

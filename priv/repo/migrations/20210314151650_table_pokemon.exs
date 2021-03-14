defmodule Pokestats.Repo.Migrations.TablePokemon do
  use Ecto.Migration

  def change do
    create table :pokemon do
      add :name, :string
      add :image, :string
      add :height, :integer
      add :weight, :integer
      add :pokeapi_id, :integer
      add :type, {:array, :string}
      add :abilities, {:array, :string}

      timestamps()
    end
  end
end

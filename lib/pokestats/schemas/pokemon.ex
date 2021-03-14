defmodule Pokestats.Pokemon do
  @moduledoc """
  This is the module responsible for the Pokemon schema
  and basic CRUD operations with it
  """
  @moduledoc since: "0.1.3"
  use Ecto.Schema
  import Ecto.Changeset

  alias Pokestats.Pokemon
  alias Pokestats.Repo

  schema "pokemon" do
    field :name, :string
    field :image, :string
    field :height, :integer
    field :weight, :integer
    field :pokeapi_id, :integer
    field :type, {:array, :string}
    field :abilities, {:array, :string}

    timestamps()
  end

  @required_fields [:name, :image, :height, :weight, :pokeapi_id, :type, :abilities]

  @doc """
  Validate `params` after manipulating struct
  onto the database.

  Returns #Ecto.Changeset<>

  ## Examples

    iex > Pokestats.Pokemon.changeset(%Pokestats.Pokemon{}, valid_params)
    #Ecto.Changeset<>
  """
  @doc since: "0.1.3"
  def changeset(pokemon, params \\ %{}) do
    pokemon
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
  end

  @doc """
  Creates a pokemon onto our database with
  the given `params`.

  Returns {:ok %Pokemon{}}

  ## Examples

    iex > Pokestats.Pokemon.create_pokemon(valid_params)
    {:ok, %Pokestats.Pokemon{}}
  """
  @doc since: "0.1.3"
  def create_pokemon(params) do
    %Pokemon{}
    |> changeset(params)
    |> Repo.insert()
  end

  @doc """
  List all pokemons of our database.

  Returns [%Pokemon{}]
  Returns []

  ## Examples

    iex > Pokestats.Pokemon.list_pokemons()
    [%Pokestats.Pokemon{}]

    iex > Pokestats.Pokemon.list_pokemons()
    []
  """
  @doc since: "0.1.3"
  def list_pokemons() do
    Pokemon
    |> Repo.all()
  end
end

defmodule Pokestats.PokemonTest do
  use ExUnit.Case, async: false
  use Pokestats.RepoCase

  doctest Pokestats.PokeApi

  setup_all do
    valid_params = %{
      name: "test",
      image: "https://test.com",
      height: 42,
      weight: 42,
      pokeapi_id: 1,
      type: ["type1", "type2"],
      abilities: ["ability1", "ability2"]
    }

    # height must be integer
    invalid_type_params = %{
      name: "test",
      image: "https://test.com",
      height: "wrong-height",
      weight: 42,
      pokeapi_id: 1,
      type: ["type1", "type2"],
      abilities: ["ability1", "ability2"]
    }

    # missing name
    missing_params = %{
      image: "https://test.com",
      height: "42",
      weight: "42",
      pokeapi_id: 1,
      type: ["type1", "type2"],
      abilities: ["ability1", "ability2"]
    }

    %{
      valid_params: valid_params,
      invalid_type_params: invalid_type_params,
      missing_params: missing_params
    }
  end

  test "changeset/2 with valid parameters", %{valid_params: valid_params} do
    changeset = Pokestats.Pokemon.changeset(%Pokestats.Pokemon{}, valid_params)
    assert true == changeset.valid?
  end

  test "changeset/2 with invalid type parameters", %{invalid_type_params: invalid_type_params} do
    changeset = Pokestats.Pokemon.changeset(%Pokestats.Pokemon{}, invalid_type_params)
    assert [height: {"is invalid", [type: :integer, validation: :cast]}] == changeset.errors
    assert false == changeset.valid?
  end

  test "changeset/2 with missing parameters", %{missing_params: missing_params} do
    changeset = Pokestats.Pokemon.changeset(%Pokestats.Pokemon{}, missing_params)
    assert [name: {"can't be blank", [validation: :required]}] == changeset.errors
    assert false == changeset.valid?
  end

  test "create_pokemon/1 with valid parameters", %{valid_params: valid_params} do
    assert {:ok, %Pokestats.Pokemon{}} = Pokestats.Pokemon.create_pokemon(valid_params)
  end

  test "create_pokemon/1 with invalid type parameters", %{
    invalid_type_params: invalid_type_params
  } do
    assert {:error, changeset} = Pokestats.Pokemon.create_pokemon(invalid_type_params)
    assert [height: {"is invalid", [type: :integer, validation: :cast]}] == changeset.errors
    assert false == changeset.valid?
  end

  test "create_pokemon/1 with missing parameters", %{missing_params: missing_params} do
    assert {:error, changeset} = Pokestats.Pokemon.create_pokemon(missing_params)
    assert [name: {"can't be blank", [validation: :required]}] == changeset.errors
    assert false == changeset.valid?
  end

  test "list_pokemons/0 with no values on the database" do
    assert [] == Pokestats.Pokemon.list_pokemons()
  end

  test "list_pokemons/0 with values on the database", %{valid_params: valid_params} do
    # Create 5 pokemons
    1..5
    |> Enum.each(fn _number -> Pokestats.Pokemon.create_pokemon(valid_params) end)

    assert pokemons_list = Pokestats.Pokemon.list_pokemons()
    assert 5 == length(pokemons_list)
  end
end

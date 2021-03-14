defmodule Pokestats.PokeApiTest do
  use ExUnit.Case, async: false

  doctest Pokestats.PokeApi

  test "list_pokemons/2" do
    assert {:ok, pokemons_list} = Pokestats.PokeApi.list_pokemons()

    first_pokemon = List.first(pokemons_list)
    assert "bulbasaur" == first_pokemon.name
    assert 2 == length(first_pokemon.type)
    assert 7 == first_pokemon.height
    assert 69 == first_pokemon.weight
  end

  test "get_pokemon/1 by name" do
    assert {:ok, pokemon} = Pokestats.PokeApi.get_pokemon("bulbasaur")
    assert "bulbasaur" == pokemon.name
    assert 2 == length(pokemon.type)
    assert 7 == pokemon.height
    assert 69 == pokemon.weight
  end

  test "get_pokemon/1 by id" do
    assert {:ok, pokemon} = Pokestats.PokeApi.get_pokemon(1)
    assert "bulbasaur" == pokemon.name
    assert 2 == length(pokemon.type)
    assert 7 == pokemon.height
    assert 69 == pokemon.weight
  end

  test "get_pokemon/1 with invalid name" do
    assert {:error, %{status: 404, message: "Not Found"}} ==
             Pokestats.PokeApi.get_pokemon("bernardes")
  end

  test "get_pokemon/1 with invalid id" do
    assert {:error, %{status: 404, message: "Not Found"}} ==
             Pokestats.PokeApi.get_pokemon(0)
  end
end

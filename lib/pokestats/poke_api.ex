defmodule Pokestats.PokeApi do
  @moduledoc """
  This is the module responsible for all the api calls to
  pokeapi.com
  """
  @moduledoc since: "0.1.0"
  use Tesla

  alias Pokestats.PokeApi

  plug Tesla.Middleware.JSON
  plug Tesla.Middleware.BaseUrl, "https://pokeapi.co/api/v2"

  @doc """
  List all pokemons registered on the api.
  Since we get the values paginated, we will
  use the `next_page` returned in each
  request and accumulate all the pokemons
  on teh `acc_list`.

  Returns {:ok, [pokemons_list]}

  ## Examples

    iex > Pokestats.PokeApi.list_pokemons()
    {:ok, [%{name: "bulbasaur", image: "...", name: "..."}, ...]}
  """
  @doc since: "0.1.0"
  def list_pokemons(next_page \\ nil, acc_list \\ []) do
    with {:ok, %Tesla.Env{body: %{"next" => next, "results" => pokemon_list}, status: 200}} <-
           PokeApi.get(next_page || "/pokemon?limit=1000") do
      formatted_pokemon_list =
        pokemon_list
        |> Enum.map(fn pokemon ->
          case get_pokemon(pokemon["name"]) do
            {:ok, pokemon} -> pokemon
            {:error, _} -> nil
          end
        end)
        |> Enum.reject(&is_nil/1)

      acc_list = acc_list ++ formatted_pokemon_list

      if is_nil(next), do: {:ok, acc_list}, else: list_pokemons(next, acc_list)
    end
  end

  @doc """
  Returns basic info about a pokemon. You can
  pass the pokemon name or is id in `name_or_id`
  parameters. If the pokemon is invalid, it will
  return error.

  Returns {:ok, pokemon_info}
  Returns {:error, error_message}

    ## Examples

    iex > Pokestats.PokeApi.get_pokemon("bulbasaur")
    {:ok, %{name: "bulbasaur", ...}}

    iex > Pokestats.PokeApi.get_pokemon(1)
    {:ok, %{name: "bulbasaur", ...}}

    iex > Pokestats.PokeApi.get_pokemon("bernardes 😂")
    {:error, %{status => 404, message: "Not Found"}}
  """
  @doc since: "0.1.0"
  def get_pokemon(name_or_id) do
    with {:ok, %Tesla.Env{body: body, status: 200}} <- PokeApi.get("/pokemon/#{name_or_id}") do
      {:ok,
       %{
         name: body["name"],
         image: body["sprites"]["other"]["official-artwork"]["front_default"],
         measurements: %{
           height: body["height"],
           weight: body["weight"]
         },
         abilities: Enum.map(body["abilities"], & &1["ability"]["name"]),
         type: Enum.map(body["types"], & &1["type"]["name"])
       }}
    else
      {:ok, %Tesla.Env{body: body, status: status}} -> {:error, %{status: status, message: body}}
    end
  end
end

package Ar.edu.unsam.algo2.grupo8.controller

import Ar.edu.unsam.algo2.grupo8.domain.Entrenador
import Ar.edu.unsam.algo2.grupo8.domain.Pokeball
import Ar.edu.unsam.algo2.grupo8.domain.Pokemon
import Ar.edu.unsam.algo2.grupo8.domain.Tipo
import Ar.edu.unsam.algo2.grupo8.repos.RepositorioPokemon
import Ar.edu.unsam.algo2.grupo8.repos.RepositorioUsuario
import net.sf.json.JSONArray
import net.sf.json.JSONObject
import org.uqbar.geodds.Point
import org.uqbar.xtrest.api.Result
import org.uqbar.xtrest.api.annotation.Body
import org.uqbar.xtrest.api.annotation.Controller
import org.uqbar.xtrest.api.annotation.Get
import org.uqbar.xtrest.api.annotation.Put
import org.uqbar.xtrest.http.ContentType
import org.uqbar.xtrest.json.JSONUtils

@Controller
class PokemonController {
	RepositorioPokemon repoPokemon = RepositorioPokemon.instance
	Entrenador user = RepositorioUsuario.instance.usuario
	extension JSONUtils = new JSONUtils

	@Get("/pokemones")
	def Result pokemones() {
		val JSONArray pokemonesArray = new JSONArray
		val pokemons = repoPokemon.pokemonesCercanos
		pokemons.forEach[pokemon|this.infoCompactadaPokemon(pokemon, pokemonesArray)]
		response.contentType = ContentType.APPLICATION_JSON
		ok(pokemonesArray.toJson)
	}

	@Get("/pokemones/:id")
	def Result pokemonesId(@Body String body) {
		val Integer idPokemon = Integer.parseInt(id)
		val pokemons = repoPokemon.searchById(idPokemon)
		response.contentType = ContentType.APPLICATION_JSON
		ok(pokemons.toJson)
	}

	@Get('/pokemonesEntrenador')
	def Result pokemonesEntrenador(@Body String body) {
		val JSONArray pokemonesJson = new JSONArray
		val pokemones = user.pokemonesAtrapados
		pokemones.forEach[pokemon|this.infoCompactadaPokemon(pokemon, pokemonesJson)]
		response.contentType = ContentType.APPLICATION_JSON
		ok(pokemonesJson.toString)
	}

	@Put('/updateTeam/')
	def Result updateTeam(@Body String body) {
		val equipoActualizado = JSONArray.fromObject(body)
		equipoActualizado.forEach[pokemon|updateEquipo(JSONObject.fromObject(pokemon))]
		ok('{ "status" : "OK" }');
	}

	@Put('/atraparPokemon/:id/:idPokeball')
	def Result atraparPokemon(@Body String body) {
		val Integer idPokemon = Integer.parseInt(id)
		val Pokemon pokemonAux = repoPokemon.searchById(idPokemon)
		val Pokemon pokemonNuevo = new Pokemon(pokemonAux.especie, pokemonAux.ubicacion, pokemonAux.genero)
		val Integer idItem = Integer.parseInt(idPokeball)

		try {
			val Pokeball item = user.itemId(idItem) as Pokeball
			val result = RepositorioUsuario.instance.usuario.atraparA(pokemonNuevo, item)
			response.contentType = ContentType.APPLICATION_JSON
			ok(result.toJson)
		} catch (Exception e) {
			badRequest(e.message)
		}
	}

	@Put('/nombrePokemon/:id')
	def Result nombrePokemon(@Body String body) {
		val Integer idPokemon = Integer.parseInt(id)
		val Pokemon pokemon = user.buscarPokemonId(idPokemon)
		pokemon.cambiarNombrePokemon(body.toString)
		response.contentType = ContentType.APPLICATION_JSON
		ok('{ "status" : "OK" }')
	}

	@Put('/pokemonesUbicacion/')
	def Result pokemonesUbicacion(@Body String body) {
		val actualizado = body.fromJson(Point)
		repoPokemon.filtrarUbicacion(actualizado)
		ok('{ "status" : "OK" }');
	}

	def infoCompactadaPokemon(Pokemon unPokemon, JSONArray unJsonArray) {
		val JSONObject unPokemonJson = new JSONObject
		val JSONObject especieJson = new JSONObject
		this.infoCompactadaEspecie(unPokemon, especieJson)
		unPokemonJson.accumulate("idRepo", unPokemon.idRepo)
		unPokemonJson.accumulate("idPokemon", unPokemon.idPokemon)
		unPokemonJson.accumulate("nombrePokemon", unPokemon.nombrePokemon)
		unPokemonJson.accumulate("especie", especieJson)
		unPokemonJson.accumulate("experiencia", unPokemon.experiencia)
		unPokemonJson.accumulate("nivel", unPokemon.nivel)
		unPokemonJson.accumulate("puntosDeAtaque", unPokemon.puntosDeAtaque)
		unPokemonJson.accumulate("estado", user.estaEnEquipo(unPokemon))
		unPokemonJson.accumulate("puntosDeVida", unPokemon.puntosDeSaludActual)
		unPokemonJson.accumulate("puntosDeVidaMax", (unPokemon.puntosDeSaludMaxima))
		unPokemonJson.accumulate("genero", unPokemon.genero)
		unJsonArray.add(unPokemonJson)
	}

	def infoCompactadaEspecie(Pokemon unPokemon, JSONObject especieJson) {
		val JSONArray tipoArrayJson = new JSONArray
		especieJson.accumulate("nombre", unPokemon.especie.nombre)
		unPokemon.especie.tipos.forEach[tipo|this.infoTipo(tipo, tipoArrayJson)]
		especieJson.accumulate("tipos", tipoArrayJson)
	}

	def infoTipo(Tipo unTipo, JSONArray unJsonArrayTipo) {
		val JSONObject tipoJson = new JSONObject
		tipoJson.accumulate("nombre", unTipo.nombre)
		unTipo.tiposFuertes.forEach[tipoFuerte|tipoJson.accumulate("tiposFuertes", tipoFuerte.nombre)]
		unTipo.tiposResistentes.forEach[tipoResistente|tipoJson.accumulate("tiposResistentes", tipoResistente.nombre)]
		unJsonArrayTipo.add(tipoJson)
	}

	def updateEquipo(JSONObject unObject) {
		var Pokemon pokemon = user.buscarPokemonId(unObject.getInt("idEntrenador"))
		user.equipo.remove(pokemon)
		pokemon.puntosDeSaludActual = unObject.getInt("puntosDeVida")
		pokemon.experiencia = unObject.getInt("experiencia")
		user.equipo.add(pokemon)
	}
}

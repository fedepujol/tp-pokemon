package Ar.edu.unsam.algo2.grupo8.controller

import Ar.edu.unsam.algo2.grupo8.domain.Entrenador
import Ar.edu.unsam.algo2.grupo8.domain.Item
import Ar.edu.unsam.algo2.grupo8.domain.Pokemon
import Ar.edu.unsam.algo2.grupo8.repos.RepositorioUsuario
import java.util.Collection
import java.util.Iterator
import java.util.Map
import net.sf.json.JSONArray
import net.sf.json.JSONObject
import org.uqbar.geodds.Point
import org.uqbar.xtrest.api.Result
import org.uqbar.xtrest.api.XTRest
import org.uqbar.xtrest.api.annotation.Body
import org.uqbar.xtrest.api.annotation.Controller
import org.uqbar.xtrest.api.annotation.Get
import org.uqbar.xtrest.api.annotation.Put
import org.uqbar.xtrest.http.ContentType
import org.uqbar.xtrest.json.JSONUtils

@Controller
class EntrenadorController {
	RepositorioUsuario repoUsuario = RepositorioUsuario.instance
	Entrenador user = RepositorioUsuario.instance.usuario
	extension JSONUtils = new JSONUtils

	@Get('/user')
	def Result user() {
		val JSONArray entrenadorJson = new JSONArray
		infoCompactadaEntrenador(entrenadorJson)
		response.contentType = ContentType.APPLICATION_JSON
		ok(entrenadorJson.toJson)
	}

	@Get('/oponentes')
	def Result oponentes() {
		val JSONArray entrenadorJson = new JSONArray
		val oponentes = repoUsuario.npcCercanos
		oponentes.forEach[oponente|this.infoCompactadaOponentes(oponente, entrenadorJson)]
		response.contentType = ContentType.APPLICATION_JSON
		ok(entrenadorJson.toJson)
	}

	@Get('/oponentes/:id')
	def Result oponentesId() {
		val Integer idEntrenador = Integer.parseInt(id)
		val entrenador = repoUsuario.searchById(idEntrenador)
		response.contentType = ContentType.APPLICATION_JSON
		ok(entrenador.toJson)
	}

	@Get('/inventarioEntrenador')
	def Result entrenadorInventario() {
		val JSONArray inventarioJson = new JSONArray
		val inventario = user.inventario
		response.contentType = ContentType.APPLICATION_JSON
		this.infoCompactadaInventario(inventario, inventarioJson)
		ok(inventarioJson.toString)
	}

	@Put('/oponentesUbicacion/')
	def Result oponentesUbicacion(@Body String body) {
		val actualizado = body.fromJson(Point)
		repoUsuario.filtrarUbicacion(actualizado)
		ok('{ "status" : "OK" }');
	}

	@Put('/updateItems/')
	def Result updateItems(@Body String body) {
		var inventario = JSONObject.fromObject(body)
		var idArray = inventario.getJSONArray("id")
		var cantidadArray = inventario.getJSONArray("cantidad")
		this.updateInventario(idArray, cantidadArray)
		ok('{ "status" : "OK" }');
	}

	@Put("/batalla/:idOp/:idPokeOp/:idPoke")
	def Result batallaEntrenadorId(@Body String body) {
		val Integer idOponente = Integer.parseInt(idOp)
		val Integer idPokemonOponente = Integer.parseInt(idPokeOp)
		val Integer idPokemon = Integer.parseInt(idPoke)
		val Double apuesta = Double.parseDouble(body.toString)
		val resultado = this.enfrentamiento(idOponente, idPokemonOponente, idPokemon, apuesta)
		response.contentType = ContentType.APPLICATION_JSON
		ok(resultado.toJson)
	}

	def infoCompactadaEntrenador(JSONArray unJsonArray) {
		val JSONObject unEntrenadorJson = new JSONObject
		val JSONArray equipoArray = new JSONArray
		val JSONArray atrapadosArray = new JSONArray
		unEntrenadorJson.accumulate("nombre", user.nombre)
		unEntrenadorJson.accumulate("perfil", user.perfil.nombre)
		unEntrenadorJson.accumulate("ubicacion", user.ubicacion)
		unEntrenadorJson.accumulate("experiencia", user.experiencia)
		unEntrenadorJson.accumulate("dinero", user.dinero)
		unEntrenadorJson.accumulate("esExperto", user.experto)
		validateArrayPokemon(equipoArray, unEntrenadorJson, "equipo", user.equipo)
		validateArrayPokemon(atrapadosArray, unEntrenadorJson, "pokemonesAtrapados", user.pokemonesAtrapados.toList)
		unEntrenadorJson.accumulate("apuesta", user.apuesta)
		unEntrenadorJson.accumulate("idPokemon", user.idPokemon)
		unJsonArray.add(unEntrenadorJson)
	}

	def validateArrayPokemon(JSONArray equipoArray, JSONObject unEntrenadorJson, String nombreArray,
		Collection<Pokemon> unArray) {
		if (!unArray.nullOrEmpty) {
			unArray.forEach[pokemon|equipoArray.add(infoCompactadaEquipo(pokemon))]
			unEntrenadorJson.accumulate(nombreArray, equipoArray)
		} else {
			unEntrenadorJson.accumulate(nombreArray, equipoArray)
		}
	}

	def infoCompactadaOponentes(Entrenador unEntrenador, JSONArray unJsonArray) {
		val JSONObject unEntrenadorJson = new JSONObject
		val JSONArray equipoArray = new JSONArray
		unEntrenadorJson.accumulate("id", unEntrenador.id)
		unEntrenadorJson.accumulate("nombre", unEntrenador.nombre)
		unEntrenadorJson.accumulate("apuesta", unEntrenador.apuesta)
		unEntrenador.equipo.forEach[pokemon|equipoArray.add(infoCompactadaEquipo(pokemon))]
		unEntrenadorJson.accumulate("pokemonesAtrapados", equipoArray)
		unJsonArray.add(unEntrenadorJson)
	}

	def infoCompactadaEquipo(Pokemon unPokemon) {
		val JSONObject pokemonJson = new JSONObject
		pokemonJson.accumulate("idRepo", unPokemon.idRepo)
		pokemonJson.accumulate("idPokemon", unPokemon.idPokemon)
		pokemonJson.accumulate("nombre", unPokemon.especie.nombre)
		pokemonJson.accumulate("experiencia", unPokemon.experiencia)
		pokemonJson.accumulate("nivel", unPokemon.nivel)
		pokemonJson.accumulate("estado", true)
		pokemonJson.accumulate("puntosDeAtaque", unPokemon.puntosDeAtaque)
		pokemonJson.accumulate("puntosDeVida", unPokemon.puntosDeSaludActual)
		pokemonJson.accumulate("puntosDeVidaMax", unPokemon.puntosDeSaludMaxima)
		pokemonJson.accumulate("genero", unPokemon.genero)
		pokemonJson
	}

	def infoCompactadaInventario(Map<Item, Integer> unInventario, JSONArray unJsonArray) {
		val JSONObject unInventarioJson = new JSONObject
		var Iterator<Map.Entry<Item, Integer>> entradas = unInventario.entrySet.iterator
		var Map.Entry<Item, Integer> entrada

		while (entradas.hasNext()) {
			entrada = entradas.next()
			unInventarioJson.accumulate("id", entrada.key.id)
			unInventarioJson.accumulate("nombre", entrada.key.nombre)
			unInventarioJson.accumulate("cantidad", entrada.value.toString)
			unJsonArray.add(unInventarioJson)
			unInventarioJson.clear
		}
	}

	def enfrentamiento(Integer unIdOponente, Integer unIdPokemonOponente, Integer unIdPokemon, Double unaApuesta) {
		val oponente = repoUsuario.searchById(unIdOponente)
		val batallasAnterior = user.batallasGanadas

		user.enfrentarseA(oponente, oponente.buscarPokemonId(unIdPokemonOponente), unaApuesta, unIdPokemon)
		user.batallasGanadas > batallasAnterior
	}

	def updateInventario(JSONArray idArray, JSONArray cantidadArray) {
		var int i = 0
		var Integer auxId
		var Integer auxCantidad
		for (i = 0; i < idArray.length; i++) {
			auxId = Integer.parseInt(idArray.get(i).toString)
			auxCantidad = Integer.parseInt(cantidadArray.get(i).toString)
			user.updateItem(user.itemId(auxId), auxCantidad)
		}
	}

	def static void main(String[] args) {
		XTRest.start(8000, EntrenadorController, PokemonController, PokeparadaController)
	}

}

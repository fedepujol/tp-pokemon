package Ar.edu.unsam.algo2.grupo8.controller

import Ar.edu.unsam.algo2.grupo8.domain.Entrenador
import Ar.edu.unsam.algo2.grupo8.domain.Pokeparada
import Ar.edu.unsam.algo2.grupo8.repos.RepositorioPokeparada
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
class PokeparadaController {
	Entrenador user = RepositorioUsuario.instance.usuario
	extension JSONUtils = new JSONUtils

	@Get('/pokeparadas')
	def Result pokeparadas() {
		val JSONArray pokeparadaJson = new JSONArray
		val pokeparadas = RepositorioPokeparada.instance.pokeparadasCercanas
		pokeparadas.forEach[pokeparada|this.infoCompactadaPokeparada(pokeparada, pokeparadaJson)]
		response.contentType = ContentType.APPLICATION_JSON
		ok(pokeparadaJson.toJson)
	}

	@Get("/pokeparadas/:id")
	def Result pokeparadasId(@Body String body) {
		val Integer idPokeparada = Integer.parseInt(id)
		val pokeparadas = RepositorioPokeparada.instance.searchById(idPokeparada)
		response.contentType = ContentType.APPLICATION_JSON
		ok(pokeparadas.toJson)

	}

	@Put('/curarEquipo/:id')
	def Result curarEquipo(@Body String body) {
		val idPokeparada = Integer.parseInt(id)
		val pokeparada = RepositorioPokeparada.instance.searchById(idPokeparada)
		pokeparada.peticionDeAcceso(user)
		pokeparada.curarPokemonesDe(user)
		pokeparada.abandonarPokeparada(user)
		response.contentType = ContentType.APPLICATION_JSON
		ok('{ "status" : "OK" }')
	}

	@Put('/pokeparadasUbicacion/')
	def Result pokeparadasUbicacion(@Body String body) {
		val actualizado = body.fromJson(Point)
		RepositorioPokeparada.instance.filtrarUbicacion(actualizado)
		ok('{ "status" : "OK" }');
	}

	def infoCompactadaPokeparada(Pokeparada unaPokeparada, JSONArray unJsonArray) {
		val JSONObject unaPokeparadaJson = new JSONObject
		val JSONObject ubicacion = new JSONObject
		unaPokeparadaJson.accumulate("id", unaPokeparada.id)
		unaPokeparadaJson.accumulate("nombre", unaPokeparada.nombre)
		ubicacion.accumulate("x", unaPokeparada.ubicacion.x)
		ubicacion.accumulate("y", unaPokeparada.ubicacion.y)
		unaPokeparadaJson.accumulate("ubicacion", ubicacion)
		unJsonArray.add(unaPokeparadaJson)
	}

}

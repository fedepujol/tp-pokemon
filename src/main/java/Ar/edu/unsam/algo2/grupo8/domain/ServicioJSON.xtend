package Ar.edu.unsam.algo2.grupo8.domain

import net.sf.json.JSONArray
import net.sf.json.JSONObject

interface ServicioJSON {
	def String getStringUpdateEspecie()

	def String getStringUpdatePokeparada()

	def String getStringUpdateUsuario()

}

class servicioJSONImplementado implements ServicioJSON {
	JSONArray jsonEspecie = new JSONArray
	
	override String getStringUpdateEspecie() {
		val JSONObject jsonEspecieVenasaur = new JSONObject => [
			element("numero", 3).element("nombre", "Venasaur").element("puntosAtaqueBase", 10).element(
				"puntosSaludBase", 352).element("descripcion", "A Venasaur es fácil verle echándose una siesta").
				accumulate("tipos", "hierba").accumulate("tipos", "veneno").element("velocidad", 17)
		]

		val JSONObject jsonEspecieIvysaur = new JSONObject => [
			element("numero", 2).element("nombre", "Ivysaur").element("puntosAtaqueBase", 15).element(
				"puntosSaludBase", 20).element("descripcion", "Este Pokémon lleva un bulbo en el lomo.").accumulate(
				"tipos", "hierba").accumulate("tipos", "veneno").element("velocidad", 8).element("evolucion", 3).
				element("nivelEvolucion", 32)
		]

		val JSONObject jsonEspecieBulbasor = new JSONObject => [
			element("numero", 1).element("nombre", "Bulbasaur").element("puntosAtaqueBase", 10).element(
				"puntosSaludBase", 15).element("descripcion",
				"A Bulbasaur es fácil verle echándose una siesta al sol.").accumulate("tipos", "hierba").accumulate(
				"tipos", "veneno").element("velocidad", 7).element("evolucion", 2).element("nivelEvolucion", 16)
		]
		
		jsonEspecie.addAll(jsonEspecieBulbasor, jsonEspecieIvysaur, jsonEspecieVenasaur)
		jsonEspecie.toString
	}

	override getStringUpdatePokeparada() {
	}

	override getStringUpdateUsuario() {
	}

}

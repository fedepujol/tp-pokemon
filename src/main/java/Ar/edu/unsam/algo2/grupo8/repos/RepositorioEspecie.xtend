package Ar.edu.unsam.algo2.grupo8.repos

import Ar.edu.unsam.algo2.grupo8.domain.BusinessException
import Ar.edu.unsam.algo2.grupo8.domain.Especie
import Ar.edu.unsam.algo2.grupo8.domain.EspecieConEvolucion
import Ar.edu.unsam.algo2.grupo8.domain.EspecieSinEvolucion
import Ar.edu.unsam.algo2.grupo8.domain.Tipo
import java.util.ArrayList
import java.util.Collection
import net.sf.json.JSONArray
import net.sf.json.JSONObject
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class RepositorioEspecie extends RepoGenerico<Especie> {
	int identificador = 1
	Collection<Especie> especies = new ArrayList<Especie>
	RepositorioTipo repoTipos = RepositorioTipo.instance
	static var RepositorioEspecie instance
	String descripcion = "Repo de Especies"

	private new() {
		descripcion = "Repositorio de Especies"
		this.create(new EspecieSinEvolucion("Abra", "Abra", 150, 300, 20, 63, repoTipos.searchByNombre(#["psiquico"])))
		this.create(
			new EspecieSinEvolucion("Bellsprout", "Bellsprout", 120, 150, 40, 69,
				repoTipos.searchByNombre(#["planta", "veneno"])))
		this.create(
			new EspecieSinEvolucion("Bullbasaur", "Bullbasaur", 130, 140, 40, 3,
				repoTipos.searchByNombre(#["planta", "veneno"])))
		this.create(
			new EspecieSinEvolucion("Caterpie", "Caterpie", 50, 10, 10, 10, repoTipos.searchByNombre(#["bicho"])))
		this.create(
			new EspecieSinEvolucion("Charmander", "Charmander", 150, 300, 20, 6, repoTipos.searchByNombre(#["fuego"])))
		this.create(
			new EspecieSinEvolucion("Dratini", "Dratini", 300, 200, 100, 6, repoTipos.searchByNombre(#["dragon"])))
		this.create(new EspecieSinEvolucion("Eevee", "Eevee", 110, 80, 50, 6, repoTipos.searchByNombre(#["normal"])))
		this.create(
			new EspecieSinEvolucion("Jigglypuff", "Jigglypuff", 110, 80, 50, 6,
				repoTipos.searchByNombre(#["normal", "hada"])))
		this.create(new EspecieSinEvolucion("Mankey", "Mankey", 100, 500, 10, 2, repoTipos.searchByNombre(#["lucha"])))
		this.create(new EspecieSinEvolucion("Meowth", "Meowth", 100, 500, 10, 2, repoTipos.searchByNombre(#["normal"])))
		this.create(new EspecieSinEvolucion("Mew", "Mew", 100, 500, 10, 2, repoTipos.searchByNombre(#["psiquico"])))
		this.create(
			new EspecieSinEvolucion("Pidgey", "Pidgey", 100, 500, 10, 2,
				repoTipos.searchByNombre(#["normal", "volador"])))
		this.create(
			new EspecieSinEvolucion("Pikachu", "Pikachu", 100, 500, 10, 5, repoTipos.searchByNombre(#["electrico"])))
		this.create(new EspecieSinEvolucion("Psyduck", "Psyduck", 100, 500, 10, 2, repoTipos.searchByNombre(#["agua"])))
		this.create(
			new EspecieSinEvolucion("Rattata", "Rattata", 150, 300, 20, 2, repoTipos.searchByNombre(#["normal"])))
		this.create(
			new EspecieSinEvolucion("Snorlax", "Snorlax", 100, 500, 10, 2, repoTipos.searchByNombre(#["normal"])))
		this.create(
			new EspecieSinEvolucion("Squirtle", "Squirtle", 150, 300, 20, 2, repoTipos.searchByNombre(#["agua"])))
		this.create(
			new EspecieSinEvolucion("Venonat", "Venonat", 100, 500, 10, 2,
				repoTipos.searchByNombre(#["bicho", "veneno"])))
		this.create(
			new EspecieSinEvolucion("Weedle", "Weedle", 100, 500, 10, 2,
				repoTipos.searchByNombre(#["bicho", "veneno"])))
			this.create(
				new EspecieSinEvolucion("Zubat", "Zubat", 150, 300, 20, 2,
					repoTipos.searchByNombre(#["veneno", "volador"])))
		}

		static def getInstance() {
			if (instance.identityEquals(null)) {
				instance = new RepositorioEspecie
			}
			instance
		}

		override create(Especie unaEspecie) {
			if (!unaEspecie.esValida) {
				throw new BusinessException("Especie invalida")
			}
			unaEspecie.identificadorEspecie = identificador
			especies.add(unaEspecie)
			identificador++
		}

		override delete(Especie unaEspecie) {
			if (!especies.contains(unaEspecie)) {
				throw new BusinessException("La Especie no existe en el Repo")
			}
			especies.remove(unaEspecie)
		}

		override update(Especie unaEspecie) {

			var Especie especieConMismoId = searchById(unaEspecie.identificadorEspecie)

			if (especieConMismoId.identityEquals(null)) {
				throw new BusinessException("No existe el objeto a actualizar")
			}
			if (!unaEspecie.esValida) {
				throw new BusinessException("Especie invalida")
			}

			especieConMismoId.puntoAtaqueBase = unaEspecie.puntoAtaqueBase
			especieConMismoId.puntoSaludBase = unaEspecie.puntoSaludBase
			especieConMismoId.velocidad = unaEspecie.velocidad
			especieConMismoId.nombre = unaEspecie.nombre
			especieConMismoId.descripcion = unaEspecie.descripcion
			especieConMismoId.tipos = unaEspecie.tipos
		}

		override searchById(int id) {
			especies.findFirst(especie|especie.identificadorEspecie == id)
		}

		override search(String unValor) {
			especies.filter(
				especie |
					especie.numeroEspecie.toString == unValor || especie.nombre.toLowerCase.contains(unValor) ||
						especie.descripcion.contains(unValor)
			).toList
		}

		override crearObjeto(JSONObject unaEspecie) {
			var Especie especie

			if (!tieneEvolucion(unaEspecie)) {

				especie = crearEspecieSinEvolucion(unaEspecie, leerJsonArray(unaEspecie.getJSONArray("tipos")))
			} else {

				especie = crearEspecieConEvolucion(unaEspecie, leerJsonArray(unaEspecie.getJSONArray("tipos")))
			}

			especie.identificadorEspecie = buscarId(buscarEspecie(unaEspecie.getInt("numero")))
			agregarOUpdate(especie)
		}

		def buscarId(Especie unaEspecie) {
			if (unaEspecie.identityEquals(null)) {
				0
			} else {
				unaEspecie.identificadorEspecie
			}

		}

		def tieneEvolucion(JSONObject jsonEspecie) {
			!jsonEspecie.get("evolucion").identityEquals(null)
		}

		def Collection<Tipo> leerJsonArray(JSONArray unJsonArray) {
			val Collection<Tipo> arrayItems = new ArrayList<Tipo>
			unJsonArray.forEach[elemento|arrayItems.add(new Tipo(elemento.toString, {}, {}))]
			arrayItems
		}

		def crearEspecieConEvolucion(JSONObject unaEspecie, Collection<Tipo> arrayTipos) {
			var especieEvolucion = buscarEspecie(unaEspecie.getInt("evolucion"))

			if (especieEvolucion.identityEquals(null)) {
				throw new BusinessException("No Existe la especie a la que evoluciona")
			}

			new EspecieConEvolucion(unaEspecie.getString("nombre"), unaEspecie.getString("descripcion"),
				unaEspecie.getInt("puntosAtaqueBase"), unaEspecie.getInt("puntosSaludBase"),
				unaEspecie.getInt("velocidad"), unaEspecie.getInt("nivelEvolucion"), unaEspecie.getInt("numero"),
				especieEvolucion, arrayTipos)
		}

		def crearEspecieSinEvolucion(JSONObject unaEspecie, Collection<Tipo> arrayTipos) {
			new EspecieSinEvolucion(unaEspecie.getString("nombre"), unaEspecie.getString("descripcion"),
				unaEspecie.getInt("puntosAtaqueBase"), unaEspecie.getInt("puntosSaludBase"),
				unaEspecie.getInt("velocidad"), unaEspecie.getInt("numero"), arrayTipos)
		}

		def buscarEspecie(int unNumero) {
			especies.findFirst(especie|especie.numeroEspecie == unNumero)
		}

		override existeEnElRepo(Especie unaEspecie) {
			especies.filter(especie|especie.numeroEspecie == unaEspecie.numeroEspecie).filterNull
		}

		override updateAll() {
			val String stringServicioJson = servicioJSON.stringUpdateEspecie
			validarServicioJson(stringServicioJson)
			leerJson(JSONArray.fromObject(stringServicioJson))
		}
	}
	
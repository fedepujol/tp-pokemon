package Ar.edu.unsam.algo2.grupo8.repos

import Ar.edu.unsam.algo2.grupo8.domain.BusinessException
import Ar.edu.unsam.algo2.grupo8.domain.Item
import Ar.edu.unsam.algo2.grupo8.domain.Pokeparada
import Ar.edu.unsam.algo2.grupo8.factory.ItemFactory
import java.util.ArrayList
import java.util.Collection
import net.sf.json.JSONArray
import net.sf.json.JSONObject
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.geodds.Point

@Accessors
class RepositorioPokeparada extends RepoGenerico<Pokeparada> {
	int identificador = 1
	Collection<Pokeparada> pokeparadas = new ArrayList<Pokeparada>
	Collection<Pokeparada> pokeparadasCercanas = new ArrayList<Pokeparada>
	static var RepositorioPokeparada instance
	String descripcion = "Repo de Pokeparadas"

	private new() {
		descripcion = "Repositorio de Pokeparadas"
		this.create(new Pokeparada("UNSAM", new Point(-38.598, -58.235), new ArrayList<Item>))
		this.create(new Pokeparada("UNLAM", new Point(-37.000, -57.100), new ArrayList<Item>))
	}

	static def getInstance() {
		if (instance.identityEquals(null)) {
			instance = new RepositorioPokeparada
		}
		instance
	}

	override create(Pokeparada unaPokeparada) {
		if (!unaPokeparada.esValida) {
			throw new BusinessException("Pokeparada invalida")
		}
		unaPokeparada.id = identificador
		pokeparadas.add(unaPokeparada)
		identificador++
	}

	override delete(Pokeparada unaPokeparada) {
		if (!pokeparadas.contains(unaPokeparada)) {
			throw new BusinessException("La pokeparada no existe en el Repo")
		}
		pokeparadas.remove(unaPokeparada)
	}

	override update(Pokeparada unaPokeparada) {
		var Pokeparada pokeparadaConMismoId = searchById(unaPokeparada.id)

		if (pokeparadaConMismoId.identityEquals(null)) {
			throw new BusinessException("No existe la pokeparada a actualizar")
		}
		if (!unaPokeparada.esValida) {
			throw new BusinessException("Pokeparada invalida")
		}
		pokeparadaConMismoId.nombre = unaPokeparada.nombre
		pokeparadaConMismoId.inventario = unaPokeparada.inventario

	}

	override searchById(int id) {
		pokeparadas.findFirst(pokeparada|pokeparada.id == id)
	}

	override search(String unValor) {
		pokeparadas.filter [ pokeparada |
			pokeparada.nombre.contains(unValor) || pokeparada.inventario.exists [ item |
				item.nombre.replace("\"", "").compareTo(unValor) == 0
			]
		].toList
	}

	override crearObjeto(JSONObject unJsonPokeparada) {
		var Pokeparada pokeparada = new Pokeparada(unJsonPokeparada.getString("nombre"),
			new Point(unJsonPokeparada.getDouble("x"), unJsonPokeparada.getDouble("y")),
			leerJsonArray(unJsonPokeparada.getJSONArray("itemsDisponibles")))

		pokeparada.id = buscarId(existeEnElRepo(pokeparada))
		agregarOUpdate(pokeparada)
	}
	
	def Collection<Item> leerJsonArray(JSONArray unJsonArray) {
		val Collection<Item> arrayItems = new ArrayList<Item>
		unJsonArray.forEach[elemento|arrayItems.add(ItemFactory.instance.getItem(elemento.toString))]
		arrayItems
	}	

	def buscarId(Iterable<Pokeparada> unaColeccion) {
		if (unaColeccion.size.equals(0)) {
			return 0
		} else {
			return unaColeccion.get(0).id
		}
	}

	override existeEnElRepo(Pokeparada unaPokeparada) {
		pokeparadas.filter [ pokeparada |
			pokeparada.ubicacion.x.equals(unaPokeparada.ubicacion.x) &&
				pokeparada.ubicacion.y.equals(unaPokeparada.ubicacion.y)
		].filterNull
	}

	override updateAll() {
		val String stringServicioJson = servicioJSON.stringUpdatePokeparada
		validarServicioJson(stringServicioJson)
		leerJson(JSONArray.fromObject(stringServicioJson))
	}

	def filtrarUbicacion(Point unaUbicacion) {
		pokeparadasCercanas = pokeparadas.filter[pokeparada|pokeparada.calcularDistancia(unaUbicacion) < 10].toList
	}	
}

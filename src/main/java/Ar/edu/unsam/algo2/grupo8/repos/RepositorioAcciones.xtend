package Ar.edu.unsam.algo2.grupo8.repos

import Ar.edu.unsam.algo2.grupo8.domain.Accion
import Ar.edu.unsam.algo2.grupo8.domain.BusinessException
import java.time.LocalDateTime
import java.util.ArrayList
import java.util.Collection
import net.sf.json.JSONObject
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class RepositorioAcciones extends RepoGenerico<Accion> {
	int identificador = 1
	static var RepositorioAcciones instance
	Collection<Accion> acciones
	String descripcion = "Repo de Acciones"
	
	new() {
		acciones = new ArrayList<Accion>
		descripcion = "Repositorio de Acciones"
	}

	static def getInstance() {
		if (instance.identityEquals(null)) {
			instance = new RepositorioAcciones
		}
		instance
	}

	override create(Accion unaAccion) {
		if (acciones.contains(unaAccion)) {
			throw new BusinessException("La accion ya existe")
		}
		acciones.add(unaAccion)
	}

	override delete(Accion unaAccion) {
		if (!acciones.contains(unaAccion)) {
			throw new BusinessException("La accion no existe")
		}
		acciones.remove(unaAccion)
	}

	override update(Accion unaAccion) {
		/*val Accion unaAccionConMismaDescripcion = search(unaAccion.descripcion).get(0)

		if (unaAccionConMismaDescripcion.identityEquals(null)) {
			throw new BusinessException("No existe la accion a actualizar")
		}*/

	}

	override searchById(int id) {
	}

	override search(String unaDescripcion) {
		//this.search(unaDescripcion, null)
	}

	def search(String unaDescripcion, LocalDateTime unaFecha) {
		/*acciones.filter [accion|
			this.match(unaDescripcion, accion.descripcion) //&& this.match(unaFecha, accion.fechaEjecucion)
		].toList*/
	}

	def match(Object expectedValue, Object realValue) {
		if (expectedValue === null) {
			return true
		}
		if (realValue === null) {
			return false
		}
		realValue.toString().toLowerCase().contains(expectedValue.toString().toLowerCase())
	}

	override crearObjeto(JSONObject unJsonObjeto) {
	}

	override existeEnElRepo(Accion unaAccion) {
		//acciones.filter[accion|accion.descripcion.identityEquals(unaAccion.descripcion)].filterNull
	}

	override updateAll() {
	}

}

package Ar.edu.unsam.algo2.grupo8.repos

import Ar.edu.unsam.algo2.grupo8.domain.Proceso
import java.util.ArrayList
import java.util.Collection
import net.sf.json.JSONObject
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.commons.model.exceptions.UserException

@Accessors
class RepositorioProceso extends RepoGenerico<Proceso> {
	int identificador = 1
	static var RepositorioProceso instance
	Collection<Proceso> procesos
	String descripcion = "Repo de Procesos"

	new() {
		procesos = new ArrayList<Proceso>
		descripcion = "Repositorio de Procesos"
	}

	static def getInstance() {
		if (instance.identityEquals(null)) {
			instance = new RepositorioProceso
		}
		instance
	}

	override create(Proceso unProceso) {
		unProceso.validarCreate()
		if (procesos.contains(unProceso)) {
			throw new UserException("El proceso ya existe")
		}
		procesos.add(unProceso)
	}

	override delete(Proceso unProceso) {
		if (!procesos.contains(unProceso)) {
			throw new UserException("El proceso no existe")
		}
		procesos.remove(unProceso)
	}

	override update(Proceso unProceso) {
		unProceso.validarCreate()
		var Proceso unProcesoConMismaDescripcion = search(unProceso.descripcion).get(0)

		if (unProcesoConMismaDescripcion.identityEquals(null)) {
			throw new UserException("No existe el proceso a actualizar")
		}
		unProcesoConMismaDescripcion = unProceso
	}

	override searchById(int id) {
	}

	override search(String unaDescripcion) {
		procesos.filter [ proceso |
			this.match(unaDescripcion, proceso.descripcion)
		].toList
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

	override existeEnElRepo(Proceso unProceso) {
		procesos.filter[proceso|proceso.descripcion == unProceso.descripcion].filterNull
	}

	override updateAll() {
	}

}

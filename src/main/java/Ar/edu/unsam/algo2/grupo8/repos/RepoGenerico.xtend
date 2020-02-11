package Ar.edu.unsam.algo2.grupo8.repos

import Ar.edu.unsam.algo2.grupo8.domain.ServicioJSON
import Ar.edu.unsam.algo2.grupo8.domain.servicioJSONImplementado
import java.util.List
import net.sf.json.JSONArray
import net.sf.json.JSONObject
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.commons.model.annotations.Observable
import org.uqbar.commons.model.exceptions.UserException

@Accessors
@Observable
abstract class RepoGenerico<T> {
	int id
	String descripcion
	ServicioJSON servicioJSON = new servicioJSONImplementado
	
	def void create(T unObjeto)

	def void delete(T unObjeto)

	def void update(T unObjeto)
	
	def T searchById(int id)

	def List<T> search(String unValor)

	def void crearObjeto(JSONObject unJsonObjeto)

	def Iterable<T> existeEnElRepo(T unObjeto)

	def void updateAll()

	def leerJson(JSONArray jsonActualizacion) {
		jsonActualizacion.forEach[JSONObject unJsonObjeto|crearObjeto(unJsonObjeto)]
	}	
	
	def agregarOUpdate(T unObjeto) {
		if (existeEnElRepo(unObjeto).size > 0) {
			update(unObjeto)
		} else
			create(unObjeto)
	}
	
	def validarServicioJson(String unStringServicioJson) {
		if (unStringServicioJson.identityEquals(null)) {
			throw new UserException("El Json no puede ser nulo")
		}
		if (unStringServicioJson.length.identityEquals(0)) {
			throw new UserException("El JsonArray no puede estar vacio")
		}
	}		
}

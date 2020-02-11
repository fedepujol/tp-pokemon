package Ar.edu.unsam.algo2.grupo8.repos

import Ar.edu.unsam.algo2.grupo8.domain.AreaGeografica
import Ar.edu.unsam.algo2.grupo8.domain.BusinessException
import java.util.ArrayList
import java.util.Collection
import net.sf.json.JSONObject
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class RepositorioAreas extends RepoGenerico<AreaGeografica> {
	Collection<AreaGeografica> areas
	static var RepositorioAreas instance
	String descripcion = "Repo de Areas"

	private new() {
		areas = new ArrayList<AreaGeografica>
		descripcion = "Repositorio de Areas"
	}

	static def getInstance() {
		if (instance.identityEquals(null)) {
			instance = new RepositorioAreas
		}
		instance
	}

	override create(AreaGeografica unArea) {
		if (areas.contains(unArea)) {
			throw new BusinessException("El Area ya existe en el repo")
		}
		areas.add(unArea)
	}

	override delete(AreaGeografica unArea) {
		if (!areas.contains(unArea)) {
			throw new BusinessException("El area no existe en el repo")
		}
		areas.remove(unArea)
	}

	override update(AreaGeografica unArea) {
		var AreaGeografica areaConMismaDescripcion = search(unArea.descripcion).get(0)

		if (areaConMismaDescripcion.identityEquals(null)) {
			throw new BusinessException("No existe el Area a actualizar")
		}
		areaConMismaDescripcion.punto1 = unArea.punto1
		areaConMismaDescripcion.punto2 = unArea.punto2
	}

	override existeEnElRepo(AreaGeografica unArea) {
		areas.filter [ area |
			area.punto1.equals(unArea.punto1) && area.punto2.equals(unArea.punto2)
		].filterNull
	}

	override searchById(int id) {
	}

	override search(String unValor) {
		areas.filter[area|area.descripcion.contains(unValor)].toList
	}

	override crearObjeto(JSONObject unJsonObjeto) {
	}

	override updateAll() {
	}

}

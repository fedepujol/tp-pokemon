package Ar.edu.unsam.algo2.grupo8.repos

import Ar.edu.unsam.algo2.grupo8.domain.BusinessException
import java.util.ArrayList
import java.util.Collection
import net.sf.json.JSONObject
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class RepoDeRepos extends RepoGenerico<RepoGenerico<?>> {
	int identificador = 1
	Collection<RepoGenerico<?>> repos = new ArrayList<RepoGenerico<?>>
	static var RepoDeRepos instance
	String descripcion = "Repo De Repos"

	private new() {
		descripcion = "Repositorio Maestro"
	}

	static def getInstance() {
		if (instance.identityEquals(null)) {
			instance = new RepoDeRepos
		}
		instance
	}

	override create(RepoGenerico<?> unRepo) {
		if(repos.contains(unRepo)){
			throw new BusinessException("El Repositorio ya esta incluido")
		}
		unRepo.id = identificador
		repos.add(unRepo)
		identificador++
	}

	override delete(RepoGenerico<?> unRepo) {
		if (!repos.contains(unRepo)) {
			throw new BusinessException("El Repositorio no existe")
		}
		repos.remove(unRepo)
	}

	override update(RepoGenerico<?> unRepo) {
	}

	override searchById(int id) {
		repos.findFirst[unRepo|unRepo.id == id]
	}

	override search(String unValor) {
		repos.filter[unRepo|unRepo.descripcion.contains(unValor)].toList
	}

	override crearObjeto(JSONObject unJsonObjeto) {
	}

	override existeEnElRepo(RepoGenerico<?> unRepo) {
		repos.filter[repo|repo.descripcion == unRepo.descripcion].filterNull
	}

	override updateAll() {
		if(repos.nullOrEmpty){
			new BusinessException("El repo se encuentra vacio")
		}
		repos.forEach[repo|repo.updateAll]
	}

}

package Ar.edu.unsam.algo2.grupo8.factory

import Ar.edu.unsam.algo2.grupo8.domain.BusinessException
import Ar.edu.unsam.algo2.grupo8.domain.Coleccionista
import Ar.edu.unsam.algo2.grupo8.domain.Criador
import Ar.edu.unsam.algo2.grupo8.domain.Luchador
import Ar.edu.unsam.algo2.grupo8.domain.PerfilEntrenador
import java.util.HashMap
import java.util.Map

class PerfilFactory {
	static var PerfilFactory instance
	Map<String, ()=>PerfilEntrenador> perfiles

	private new() {
		this.initialize
	}

	static def getInstance() {
		if (instance.identityEquals(null)) {
			instance = new PerfilFactory()
		}
		instance
	}

	def void initialize() {
		perfiles = new HashMap<String, ()=>PerfilEntrenador> => [
			put("luchador", [|new Luchador])
			put("criador", [|new Criador])
			put("coleccionista", [|new Coleccionista])
		]
	}

	def getPerfil(String unPerfil) {
		val perfil = busqueda(unPerfil)
		if (perfil.identityEquals(null)) {
			throw new BusinessException("Error en el perfil: El Perfil Entrenador es nulo")
		}
		perfil
	}

	def busqueda(String unPerfil) {
		perfiles.get(unPerfil).apply
	}
}

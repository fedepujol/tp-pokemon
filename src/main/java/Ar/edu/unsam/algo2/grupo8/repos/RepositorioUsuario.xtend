package Ar.edu.unsam.algo2.grupo8.repos

import Ar.edu.unsam.algo2.grupo8.domain.BusinessException
import Ar.edu.unsam.algo2.grupo8.domain.Coleccionista
import Ar.edu.unsam.algo2.grupo8.domain.Criador
import Ar.edu.unsam.algo2.grupo8.domain.Entrenador
import Ar.edu.unsam.algo2.grupo8.domain.Luchador
import Ar.edu.unsam.algo2.grupo8.domain.Pokeball
import Ar.edu.unsam.algo2.grupo8.domain.Pokemon
import Ar.edu.unsam.algo2.grupo8.domain.ServicioJSON
import Ar.edu.unsam.algo2.grupo8.factory.PerfilFactory
import java.util.ArrayList
import java.util.Collection
import net.sf.json.JSONArray
import net.sf.json.JSONObject
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.geodds.Point

@Accessors
class RepositorioUsuario extends RepoGenerico<Entrenador> {
	int identificador = 1
	String descripcion
	ServicioJSON servicioJSON
	static var RepositorioUsuario instance
	Entrenador usuario
	Collection<Entrenador> npc = new ArrayList<Entrenador>
	Collection<Entrenador> npcCercanos = new ArrayList<Entrenador>

	private new() {
		descripcion = "Repositorio de Npc"
		
		usuario = new Entrenador("Red", new Luchador(), new Point(-38.598, -58.235), 0)
		usuario.id = identificador
		identificador++
		usuario.adquirirItem(new Pokeball("Pokeball", 2.5, 3), 20)
		usuario.adquirirItem(new Pokeball("Superball", 5, 10), 20)
		
		this.create(new Entrenador("Azul", new Coleccionista(), new Point(-38.598, -58.235), 500.6))
		this.create(new Entrenador("Jeronimo", new Luchador(), new Point(-38.598, -58.235), 2050.87))
		this.create(new Entrenador("Jon", new Criador(), new Point(-38.598, -58.235), 5000.3))
		this.create(new Entrenador("Jose", new Criador(), new Point(-37.000, -57.000), 10000.5))
		this.create(new Entrenador("Celeste", new Luchador(), new Point(-37.000, -57.000), 400.9))
		this.create(new Entrenador("German", new Coleccionista(), new Point(-39.000, -59.000), 600))
		this.create(new Entrenador("Manuel", new Coleccionista(), new Point(-39.000, -59.000), 550.1))
		this.create(new Entrenador("Nicolas", new Luchador(), new Point(-39.000, -59.000), 891.45))
		this.create(new Entrenador("Amelie", new Luchador(), new Point(-40.500, -58.365), 605.4))
		this.create(new Entrenador("Patrick", new Criador(), new Point(-40.500, -58.365), 8465.15))
		this.npc.forEach[entrenador|inicializarEquipo(entrenador)]
	}

	static def getInstance() {
		if (instance.identityEquals(null)) {
			instance = new RepositorioUsuario
		}
		instance
	}

	override create(Entrenador unUsuario) {
		if (!unUsuario.esValido) {
			throw new BusinessException("Usuario invalido")
		}
		unUsuario.id = identificador
		npc.add(unUsuario)
		identificador++
	}

	override delete(Entrenador unUsuario) {
		if (!npc.contains(unUsuario)) {
			throw new BusinessException("El usuario no existe en el repo")
		}
		npc.remove(unUsuario)
	}

	override update(Entrenador unUsuario) {
		var Entrenador usuarioConMismoId = searchById(unUsuario.id)

		if (usuarioConMismoId.identityEquals(null)) {
			throw new BusinessException("No existe el usuario a actualizar")
		}
		if (!unUsuario.esValido) {
			throw new BusinessException("Usuario invalida")
		}
		usuarioConMismoId.nombre = unUsuario.nombre
		usuarioConMismoId.ubicacion = unUsuario.ubicacion
		usuarioConMismoId.perfil = unUsuario.perfil

	}

	override searchById(int id) {
		npc.findFirst[usuario|usuario.id == id]
	}

	override search(String unValor) {
		npc.filter [ usuario |
			usuario.nombre.contains(unValor) || usuario.mail.contains(unValor)
		].toList
	}

	def crearPerfil(String unPerfil) {
		PerfilFactory.instance.getPerfil(unPerfil.toLowerCase)
	}

	override crearObjeto(JSONObject unJsonUsuario) {
		var Entrenador usuario = new Entrenador(unJsonUsuario.getString("nombre"),
			crearPerfil(unJsonUsuario.getString("perfil")),
			new Point(unJsonUsuario.getDouble("x"), unJsonUsuario.getDouble("y")), unJsonUsuario.getDouble("dinero"))

		usuario.id = buscarId(existeEnElRepo(usuario))
		agregarOUpdate(usuario)
	}

	def buscarId(Iterable<Entrenador> usuarios) {
		if (!usuarios.size.equals(0)) {
			usuarios.get(0).id
		}
	}

	override existeEnElRepo(Entrenador unUsuario) {
		npc.filter [ usuario |
			usuario.nombre == unUsuario.nombre || usuario.mail == unUsuario.mail
		].filterNull
	}

	override updateAll() {
		val String stringServicioJson = servicioJSON.stringUpdateUsuario
		validarServicioJson(stringServicioJson)
		leerJson(JSONArray.fromObject(stringServicioJson))
	}

	def filtrarUbicacion(Point unaUbicacion) {
		npcCercanos = npc.filter[usuario|usuario.distanciaRespectoAUnPunto(unaUbicacion) < 5].toList
	}

	def inicializarEquipo(Entrenador unEntrenador) {
		var Pokemon unPokemon
		for (var i = 0; i < 2; i++) {
			unPokemon = RepositorioPokemon.instance.pokemonRandom
			unPokemon.idPokemon = i + 1
			unEntrenador.equipo.add(unPokemon)
		}
	}

}

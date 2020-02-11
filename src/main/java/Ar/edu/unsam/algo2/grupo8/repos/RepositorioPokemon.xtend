package Ar.edu.unsam.algo2.grupo8.repos

import Ar.edu.unsam.algo2.grupo8.domain.BusinessException
import Ar.edu.unsam.algo2.grupo8.domain.Pokemon
import Ar.edu.unsam.algo2.grupo8.domain.Randomize
import Ar.edu.unsam.algo2.grupo8.domain.ServicioJSON
import java.util.ArrayList
import java.util.Collection
import net.sf.json.JSONObject
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.geodds.Point

@Accessors
class RepositorioPokemon extends RepoGenerico<Pokemon> {
	int identificador = 1
	ServicioJSON servicioJSON
	Collection<Pokemon> pokemones = new ArrayList<Pokemon>
	Collection<Pokemon> pokemonesCercanos = new ArrayList<Pokemon>
	RepositorioEspecie repoEspecie = RepositorioEspecie.instance
	static var RepositorioPokemon instance
	String descripcion

	private new() {
		descripcion = "Repositorio de Pokemones"

		this.create(new Pokemon(repoEspecie.search("Abra").get(0), new Point(-38.598, -58.235), "Macho"))
		this.create(new Pokemon(repoEspecie.search("Bellsprout").get(0), new Point(-38.587, -58.235), "Hembra"))
		this.create(new Pokemon(repoEspecie.search("Bullbasaur").get(0), new Point(-38.400, -58.000), "Hembra"))
		this.create(new Pokemon(repoEspecie.search("Caterpie").get(0), new Point(-38.400, -58.000), "Hembra"))
		this.create(new Pokemon(repoEspecie.search("Charmander").get(0), new Point(-38.400, -58.000), "Macho"))
		this.create(new Pokemon(repoEspecie.search("Dratini").get(0), new Point(-30.000, -51.000), "Hembra"))
		this.create(new Pokemon(repoEspecie.search("Eevee").get(0), new Point(-30.000, -51.000), "Macho"))
		this.create(new Pokemon(repoEspecie.search("Jigglypuff").get(0), new Point(-30.000, -51.000), "Macho"))
		this.create(new Pokemon(repoEspecie.search("Mankey").get(0), new Point(-39.000, -59.000), "Hembra"))
		this.create(new Pokemon(repoEspecie.search("Meowth").get(0), new Point(-39.000, -59.000), "Hembra"))
		this.create(new Pokemon(repoEspecie.search("Mew").get(0), new Point(-39.000, -59.000), "Macho"))
		this.create(new Pokemon(repoEspecie.search("Pidgey").get(0), new Point(-38.900, -54.500), "Hembra"))
		this.create(new Pokemon(repoEspecie.search("Pikachu").get(0), new Point(-38.900, -54.500), "Macho"))
		this.create(new Pokemon(repoEspecie.search("Psyduck").get(0), new Point(-38.900, -54.500), "Macho"))
		this.create(new Pokemon(repoEspecie.search("Rattata").get(0), new Point(-38.900, -54.500), "Hembra"))
		this.create(new Pokemon(repoEspecie.search("Snorlax").get(0), new Point(-39.200, -54.900), "Hembra"))
		this.create(new Pokemon(repoEspecie.search("Squirtle").get(0), new Point(-39.200, -54.900), "Macho"))
		this.create(new Pokemon(repoEspecie.search("Venonat").get(0), new Point(-39.200, -54.900), "Hembra"))
		this.create(new Pokemon(repoEspecie.search("Weedle").get(0), new Point(-40.587, -54.231), "Macho"))
		this.create(new Pokemon(repoEspecie.search("Zubat").get(0), new Point(-40.587, -54.231), "Macho"))
	}

	static def getInstance() {
		if (instance.identityEquals(null)) {
			instance = new RepositorioPokemon
		}
		instance
	}

	override create(Pokemon unPokemon) {
		if (!unPokemon.esValido) {
			throw new BusinessException("Pokemon invalido")
		}
		unPokemon.idRepo = identificador
		unPokemon.puntosDeSaludActual = unPokemon.puntosDeSaludActual / (2 + (unPokemon.idRepo / 10))
		pokemones.add(unPokemon)
		identificador++
	}

	override delete(Pokemon unPokemon) {
		if (!pokemones.contains(unPokemon)) {
			throw new BusinessException("El Pokemon no existe en el repo")
		}
		pokemones.remove(unPokemon)
	}

	override update(Pokemon unObjeto) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

	override searchById(int id) {
		pokemones.findFirst[pokemon|pokemon.idRepo === id]
	}

	override search(String unValor) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

	override crearObjeto(JSONObject unJsonObjeto) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

	override existeEnElRepo(Pokemon unObjeto) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

	override updateAll() {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

	def pokemonRandom() {
		val random = new Randomize
		pokemones.get(random.aplicarRandomValores(0, pokemones.size))
	}

	def filtrarUbicacion(Point unaUbicacion) {
		pokemonesCercanos = pokemones.filter[pokemon|pokemon.distanciaRespectoAUnPunto(unaUbicacion) < 5].toList
	}

}

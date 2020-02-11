package Ar.edu.unsam.algo2.grupo8.domain

import Ar.edu.unsam.algo2.grupo8.repos.RepoGenerico
import Ar.edu.unsam.algo2.grupo8.repos.RepositorioUsuario
import java.time.LocalDate
import java.time.LocalDateTime
import java.time.LocalTime
import java.time.format.DateTimeFormatter
import java.util.ArrayList
import java.util.Collection
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.commons.model.annotations.Observable
import org.uqbar.commons.model.exceptions.UserException
import org.uqbar.geodds.Point

@Accessors
@Observable
abstract class Proceso{
	String descripcion
	LocalDateTime fechaEjecucion
	DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss")
	String formattedDateTime

	def void doExecute()

	def void validarColeccion()

	def void validarCreate()

}

@Accessors
@Observable
class ProcesoMultiple extends Proceso {
	List<Proceso> procesos

	new(List<Proceso> unosProcesos, String unaDescripcion) {
		procesos = unosProcesos
		descripcion = unaDescripcion
	}

	override doExecute() {
		validarColeccion
		fechaEjecucion = LocalDateTime.of(LocalDate.now, LocalTime.now)
		formattedDateTime = fechaEjecucion.format(formatter)
		procesos.forEach[proceso|proceso.doExecute()]
	}

	override validarColeccion() {
		if (procesos.identityEquals(null)) {
			throw new UserException("Error: Lista de Procesos nula")
		}
		if (procesos.size == 0) {
			throw new UserException("Error: Lista de Procesos vacia")
		}
	}

	override validarCreate() {

		if (descripcion == "" && descripcion.length == 0) {
			throw new UserException("Por favor, ingrese una descripcion")
		}

		this.validarColeccion()
	}

}

@Accessors
@Observable
class Actualizacion extends Proceso {
	Collection<RepoGenerico<?>> repositorios

	new(Collection<RepoGenerico<?>> unosRepos, String unaDescripcion) {
		repositorios = unosRepos
		descripcion = unaDescripcion
	}

	override doExecute() {
		this.validarColeccion
		fechaEjecucion = LocalDateTime.of(LocalDate.now, LocalTime.now)
		formattedDateTime = fechaEjecucion.format(formatter)
		repositorios.forEach[repo|repo.updateAll]
	}

	override validarCreate() {
		if (descripcion == "" && descripcion.length == 0) {
			throw new UserException("La descripcion no puede ser vacia")
		}
		this.validarColeccion
	}

	override validarColeccion() {
		if (repositorios.identityEquals(null)) {
			throw new UserException("La lista de Repositorios no puede ser nula")
		}
		if (repositorios.size == 0) {
			throw new UserException("La lista de Repositorios no puede estar vacia")
		}
	}

}

@Accessors
@Observable
class AgregarAcciones extends Proceso {
	List<Accion> acciones = new ArrayList<Accion>
	var RepositorioUsuario repoUsuario = RepositorioUsuario.instance

	new(List<Accion> unasAcciones, String unaDescripcion) {
		acciones = unasAcciones
		descripcion = unaDescripcion
	}

	override doExecute() {
		validarColeccion
		fechaEjecucion = LocalDateTime.of(LocalDate.now, LocalTime.now)
		formattedDateTime = fechaEjecucion.format(formatter)
		repoUsuario.npc.forEach[usuario|acciones.forEach[accion|agregarAccionUsuario(usuario, accion)]]
	}

	override validarColeccion() {
		if (acciones.identityEquals(null)) {
			throw new UserException("Error: Lista de Acciones nula")
		}
		if (acciones.size == 0) {
			throw new UserException("Error: Lista de Acciones vacia")
		}
	}

	def agregarAccionUsuario(Entrenador unUsuario, Accion unaAccion) {
		if (unUsuario.acciones.contains(unaAccion)) {
			throw new UserException("Error: Al agregar accion. Accion duplicada")
		}
		unUsuario.acciones.add(unaAccion)
	}

	override validarCreate() {
		if (descripcion == "") {
			throw new UserException("La descripcion no puede estar vacia")
		}
		this.validarColeccion()
	}

}

@Accessors
class RemoverAcciones extends AgregarAcciones {

	new(List<Accion> unasAcciones, String unaDescripcion) {
		super(unasAcciones, unaDescripcion)
	}

	override doExecute() {
		validarColeccion()
		fechaEjecucion = LocalDateTime.of(LocalDate.now, LocalTime.now)
		formattedDateTime = fechaEjecucion.format(formatter)
		repoUsuario.npc.forEach[usuario|acciones.forEach[accion|removerAccionUsuario(usuario, accion)]]
	}

	def removerAccionUsuario(Entrenador unUsuario, Accion unaAccion) {
		if (!unUsuario.acciones.contains(unaAccion)) {
			throw new UserException("Error: Al eliminar accion. Accion no encontrada")
		}
		unUsuario.acciones.remove(unaAccion)
	}
}

@Accessors
@Observable
class PoblarArea extends Proceso {
	Integer nivelMinimo
	Integer nivelMaximo
	Double densidad
	AreaGeografica area
	Randomize random = new Randomize
	List<Especie> especies
	List<String> genero = new ArrayList<String>
	Collection<Pokemon> pokemonCreados = new ArrayList<Pokemon>

	new(AreaGeografica unArea, int unNivelMinimo, int unNivelMaximo, double unaDensidad, List<Especie> unasEspecies,
		String unaDescripcion) {
		area = unArea
		nivelMaximo = unNivelMaximo
		nivelMinimo = unNivelMinimo
		densidad = unaDensidad
		especies = unasEspecies
		genero.addAll("Hembra", "Macho")
		descripcion = unaDescripcion
	}

	def void setNivelMinimo(Integer unInteger) {
		if (unInteger !== null && unInteger.intValue >= nivelMaximo.intValue) {
			throw new UserException("El Nivel Minimo no puede ser mayor al maximo")
		}
		this.nivelMinimo = unInteger
	}

	def agregarEspecie(Especie unaEspecie) {
		if (especies.contains(unaEspecie)) {
			throw new UserException("Esta especie ya esta en el listado")
		}
		especies.add(unaEspecie)
	}

	override doExecute() {
		this.validarColeccion
		fechaEjecucion = LocalDateTime.of(LocalDate.now, LocalTime.now)
		formattedDateTime = fechaEjecucion.format(formatter)
		var int i
		var Pokemon pokemon
		for (i = 1; i < area.cantidadDePokemonesACrear(densidad); i++) {
			pokemon = new Pokemon(especieRandom, area.ubicacionRandom, randomGenero)
			pokemon.experiencia = pokemon.calcularExperienciaParaNivel(nivelRandom)
			pokemonCreados.add(pokemon)
		}
	}

	override validarCreate() {

		if (descripcion == "" && descripcion.length == 0) {
			throw new UserException("La descripcion no puede estar vacia")
		}
		if (area === null) {
			throw new UserException("Area nula")
		}
		if (densidad == 0) {
			throw new UserException("La densidad no puede ser 0")
		}

		this.validarColeccion
		this.validarNiveles
	}

	override validarColeccion() {
		if (especies.identityEquals(null)) {
			throw new UserException("La lista de especies no puede ser nula")
		}
		if (especies.size == 0) {
			throw new UserException("La lista de especies no puede estar vacia")
		}
	}

	def validarNiveles() {
		if (nivelMinimo === null && nivelMaximo === null) {
			throw new UserException("Los niveles no puden ser nulos")
		}
		if (nivelMinimo === 0 && nivelMaximo === 0) {
			throw new UserException("Los niveles no pueden ser iguales a 0")
		}
	}

	def nivelRandom() {
		random.aplicarRandomValores(nivelMinimo, nivelMaximo)
	}

	def Especie especieRandom() {
		especies.get(random.aplicarRandomValores(0, especies.size))
	}

	def randomGenero() {
		genero.get(random.aplicarRandomValores(0, genero.size))
	}

}

@Accessors
@Observable
class AreaGeografica {
	Point punto1
	Point punto2
	Randomize random = new Randomize
	String descripcion

	new(Point _punto1, Point _punto2, String unaDescripcion) {
		descripcion = unaDescripcion
		validarPuntos(_punto1, _punto2)
	}

	def validarPuntos(Point unPunto1, Point unPunto2) {
		if (unPunto1.x > unPunto2.x && unPunto1.y > unPunto2.y) {
			punto1 = unPunto1
			punto2 = unPunto2
		} else {
			punto1 = unPunto2
			punto2 = unPunto1
		}
	}

	def calcularAreaGeografica() {
		((punto1.getX() - punto2.getX()) * (punto1.getY() - punto2.getY()))
	}

	def cantidadDePokemonesACrear(double unaDensidad) {
		Math.abs((calcularAreaGeografica * unaDensidad))
	}

	def ubicacionRandom() {
		new Point(random.aplicarRandomValores(punto2.getX, punto1.getX),
			random.aplicarRandomValores(punto2.getY, punto1.getY))
	}
}

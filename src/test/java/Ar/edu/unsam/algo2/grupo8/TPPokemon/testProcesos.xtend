package Ar.edu.unsam.algo2.grupo8.TPPokemon

import Ar.edu.unsam.algo2.grupo8.domain.Accion
import Ar.edu.unsam.algo2.grupo8.domain.Actualizacion
import Ar.edu.unsam.algo2.grupo8.domain.Administrador
import Ar.edu.unsam.algo2.grupo8.domain.AgregarAcciones
import Ar.edu.unsam.algo2.grupo8.domain.AreaGeografica
import Ar.edu.unsam.algo2.grupo8.domain.BusinessException
import Ar.edu.unsam.algo2.grupo8.domain.Entrenador
import Ar.edu.unsam.algo2.grupo8.domain.Especie
import Ar.edu.unsam.algo2.grupo8.domain.EspecieConEvolucion
import Ar.edu.unsam.algo2.grupo8.domain.Luchador
import Ar.edu.unsam.algo2.grupo8.domain.NotificadorNivelMasAlto
import Ar.edu.unsam.algo2.grupo8.domain.NotificadorNivelMultiploDe5
import Ar.edu.unsam.algo2.grupo8.domain.NotificadorSuperaAmigos
import Ar.edu.unsam.algo2.grupo8.domain.PoblarArea
import Ar.edu.unsam.algo2.grupo8.domain.Proceso
import Ar.edu.unsam.algo2.grupo8.domain.ProcesoMultiple
import Ar.edu.unsam.algo2.grupo8.domain.RemoverAcciones
import Ar.edu.unsam.algo2.grupo8.domain.ServicioJSON
import Ar.edu.unsam.algo2.grupo8.domain.Tipo
import Ar.edu.unsam.algo2.grupo8.factory.ItemFactory
import Ar.edu.unsam.algo2.grupo8.repos.RepoGenerico
import Ar.edu.unsam.algo2.grupo8.repos.RepositorioEspecie
import Ar.edu.unsam.algo2.grupo8.repos.RepositorioPokeparada
import Ar.edu.unsam.algo2.grupo8.repos.RepositorioUsuario
import Ar.edu.unsam.algo2.grupo8.sender.StubMailSender
import java.util.ArrayList
import java.util.Collection
import java.util.List
import net.sf.json.JSONArray
import net.sf.json.JSONObject
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.uqbar.commons.model.exceptions.UserException
import org.uqbar.geodds.Point

import static org.mockito.Mockito.*

class testProcesos {
	Entrenador ash
	RepositorioEspecie especies
	RepositorioPokeparada pokeparadas
	RepositorioUsuario usuarios
	ItemFactory itemFactory
	Administrador admin
	AreaGeografica unArea
	StubMailSender stubMailSender
	NotificadorSuperaAmigos notificadorSuperaAmigos
	NotificadorNivelMasAlto notificadorNivelMasAlto
	NotificadorNivelMultiploDe5 notificadorNivelMultiploDe5
	JSONObject jsonPokeparada = new JSONObject
	JSONObject jsonPokeparada2 = new JSONObject
	JSONObject jsonEspecieBulbasor = new JSONObject
	JSONObject jsonEspecieIvysaur = new JSONObject
	JSONObject jsonEspecieVenasaur = new JSONObject
	JSONObject jsonUsuario1 = new JSONObject
	JSONObject jsonUsuario2 = new JSONObject
	JSONArray jsonArrayEspecies = new JSONArray
	JSONArray jsonInventario = new JSONArray
	JSONArray jsonArrayPokeparadas = new JSONArray
	JSONArray jsonArrayUsuarios = new JSONArray
	ProcesoMultiple procesoMultiple
	Actualizacion procesoActualizacion
	AgregarAcciones procesoAgregarAcciones
	RemoverAcciones procesoEliminarAcciones
	PoblarArea procesoPoblarArea
	Tipo tipoAgua
	Especie wartortle
	Especie squirtle
	ServicioJSON unServicioJSONmockeado = mock(ServicioJSON)
	Collection<Tipo> tiposSquirtle = new ArrayList<Tipo>
	Collection<RepoGenerico<?>> reposActualizar = new ArrayList<RepoGenerico<?>>
	List<Especie> especiesProceso = new ArrayList<Especie>
	List<Accion> accionesAAgregar = new ArrayList<Accion>
	List<Accion> accionesAEliminar = new ArrayList<Accion>
	List<Proceso> procesos = new ArrayList<Proceso>

	@Before
	def void init() throws SecurityException, NoSuchFieldException, IllegalArgumentException, IllegalAccessException{
		admin = Administrador.instance
		itemFactory = ItemFactory.instance
		usuarios = RepositorioUsuario.instance
		especies = RepositorioEspecie.instance
		pokeparadas = RepositorioPokeparada.instance
		especies.servicioJSON = unServicioJSONmockeado
		pokeparadas.servicioJSON = unServicioJSONmockeado
		usuarios.servicioJSON = unServicioJSONmockeado
		stubMailSender = new StubMailSender
		notificadorSuperaAmigos = new NotificadorSuperaAmigos(stubMailSender, "Superaste a tus Amigos")
		notificadorNivelMasAlto = new NotificadorNivelMasAlto(stubMailSender, "Llegaste al nivel mas alto")
		notificadorNivelMultiploDe5 = new NotificadorNivelMultiploDe5("Recompensa 5x")
		ash = new Entrenador("Ash", new Luchador(), new Point(-35.365, -34.214), 250.4)
		usuarios.npc.add(ash)
		reposActualizar => [
			add(especies)
			add(pokeparadas)
			add(usuarios)
		]
		accionesAAgregar => [
			add(notificadorSuperaAmigos)
			add(notificadorNivelMasAlto)
			add(notificadorNivelMultiploDe5)
		]
		accionesAEliminar => [
			add(notificadorSuperaAmigos)
		]

		tipoAgua = new Tipo("Agua", null, null)
		tiposSquirtle.add(tipoAgua)
		wartortle = new EspecieConEvolucion("Wartortle", "Es hermoso", 50, 40, 50, 36, 3, null, tiposSquirtle)
		squirtle = new EspecieConEvolucion("Squirtle", "Vamo a calmarno", 10, 20, 10, 16, 2, wartortle, tiposSquirtle)
		especiesProceso.addAll(wartortle, squirtle)
		unArea = new AreaGeografica(new Point(-39.651, -38.956), new Point(-23.564, -23.012), "UNSAM")
		procesoPoblarArea = new PoblarArea(unArea, 1, 10, 10.5, especiesProceso, "Poblar Area UNSAM")

		procesoEliminarAcciones = new RemoverAcciones(accionesAEliminar, "Remover acciones")
		procesoEliminarAcciones => [
			repoUsuario.npc = usuarios.npc
		]
		procesoAgregarAcciones = new AgregarAcciones(accionesAAgregar, "Agregar Acciones")
		procesoAgregarAcciones => [
			repoUsuario.npc = usuarios.npc
		]
		procesoActualizacion = new Actualizacion(reposActualizar, "Actualizar los repos")

		procesos => [
			add(procesoActualizacion)
			add(procesoAgregarAcciones)
			add(procesoEliminarAcciones)
			add(procesoPoblarArea)
		]

		procesoMultiple = new ProcesoMultiple(procesos, "Descripcion Multiple")
		jsonInventario.addAll("pokebola", "pocion")
		jsonPokeparada.accumulate("nombre", "Pokeparada Unsam").element("x", -34.1325).element("y", -34.124).accumulate(
			"itemsDisponibles", jsonInventario)

		jsonInventario.clear
		jsonInventario.addAll("superbola", "superpocion")
		jsonPokeparada2.accumulate("nombre", "Pokeparada Olivos").element("x", -35.987).element("y", -33.654).
			accumulate("itemsDisponibles", jsonInventario)

		jsonArrayPokeparadas.addAll(jsonPokeparada, jsonPokeparada2)

		jsonEspecieIvysaur.element("numero", 2).element("nombre", "Ivysaur").element("puntosAtaqueBase", 15).element(
			"puntosSaludBase", 20).element("descripcion", "Este Pokémon lleva un bulbo en el lomo.").accumulate("tipos",
			"hierba").accumulate("tipos", "veneno").element("velocidad", 8).element("evolucion", 3).element(
			"nivelEvolucion", 32)

		jsonEspecieBulbasor.element("numero", 1).element("nombre", "Bulbasaur").element("puntosAtaqueBase", 10).element(
			"puntosSaludBase", 15).element("descripcion", "A Bulbasaur es fácil verle echándose una siesta al sol.").
			accumulate("tipos", "hierba").accumulate("tipos", "veneno").element("velocidad", 7).element("evolucion", 2).
			element("nivelEvolucion", 16)
		jsonEspecieVenasaur.element("numero", 3).element("nombre", "Venasaur").element("puntosAtaqueBase", 10).element(
			"puntosSaludBase", 352).element("descripcion", "A Venasaur es fácil verle echándose una siesta").
			accumulate("tipos", "hierba").accumulate("tipos", "veneno").element("velocidad", 17)

		jsonArrayEspecies.addAll(jsonEspecieVenasaur, jsonEspecieIvysaur, jsonEspecieBulbasor)

		jsonUsuario1.element("nombre", "Roberto").element("perfil", "luchador").element("x", 33.3365).element("y",
			32.334)
		jsonUsuario2.element("nombre", "Jose").element("perfil", "coleccionista").element("x", 38.3365).element("y",
			38.334)
		jsonArrayUsuarios.addAll(jsonUsuario1, jsonUsuario2)

		var instanceAdmin = admin.class.getDeclaredField("instance")
		instanceAdmin.setAccessible(true)
		instanceAdmin.set(null, null)
		var instanceEspecies = especies.class.getDeclaredField("instance")
		instanceEspecies.setAccessible(true)
		instanceEspecies.set(null, null)
		var instancePokeparadas = pokeparadas.class.getDeclaredField("instance")
		instancePokeparadas.setAccessible(true)
		instancePokeparadas.set(null, null)
		var instanceUsuarios = usuarios.class.getDeclaredField("instance")
		instanceUsuarios.setAccessible(true)
		instanceUsuarios.set(null, null)
	}

	@Test(expected=BusinessException) // Arreglar
	def testProcesoActualizacionEjecutadoPorElAdminActualiza() {
		when(unServicioJSONmockeado.stringUpdateEspecie).thenReturn(jsonArrayEspecies.toString)
		when(unServicioJSONmockeado.stringUpdatePokeparada).thenReturn(jsonArrayPokeparadas.toString)
		when(unServicioJSONmockeado.stringUpdateUsuario).thenReturn(jsonArrayUsuarios.toString)
		admin.ejecutarProceso(procesoActualizacion)
		Assert.assertEquals(2, pokeparadas.pokeparadas.size)
	}

	def testProcesoActualizacionEjecutadoPorElAdminDaErrorDeServicioJSONArrayJSONInvalido() {
		when(unServicioJSONmockeado.stringUpdateEspecie).thenReturn(jsonArrayEspecies.toString)
		when(unServicioJSONmockeado.stringUpdatePokeparada).thenReturn(jsonPokeparada.toString)
		when(unServicioJSONmockeado.stringUpdateUsuario).thenReturn(jsonArrayUsuarios.toString)
		admin.ejecutarProceso(procesoActualizacion)
	}

	@Test(expected=UserException)
	def testProcesoActualizacionEjecutadoPorElAdminErrorServicioJSONStringNulo() {
		when(unServicioJSONmockeado.stringUpdateEspecie).thenReturn(null)
		when(unServicioJSONmockeado.stringUpdatePokeparada).thenReturn(jsonArrayPokeparadas.toString)
		when(unServicioJSONmockeado.stringUpdateUsuario).thenReturn(jsonArrayUsuarios.toString)
		admin.ejecutarProceso(procesoActualizacion)
	}

	@Test(expected=UserException)
	def testProcesoActualizacionEjecutadoPorElAdminErrorServicioJSONStringVacio() {
		when(unServicioJSONmockeado.stringUpdateEspecie).thenReturn("")
		when(unServicioJSONmockeado.stringUpdatePokeparada).thenReturn(jsonArrayPokeparadas.toString)
		when(unServicioJSONmockeado.stringUpdateUsuario).thenReturn(jsonArrayUsuarios.toString)
		admin.ejecutarProceso(procesoActualizacion)
	}

	@Test(expected=UserException)
	def testProcesoActualizacionEjecutadoPorElAdminErrorProcesoColeccionVacia() {
		when(unServicioJSONmockeado.stringUpdateEspecie).thenReturn(jsonArrayEspecies.toString)
		when(unServicioJSONmockeado.stringUpdatePokeparada).thenReturn(jsonArrayPokeparadas.toString)
		when(unServicioJSONmockeado.stringUpdateUsuario).thenReturn(jsonArrayUsuarios.toString)
		procesoActualizacion.repositorios.clear
		admin.ejecutarProceso(procesoActualizacion)
	}

	@Test(expected=UserException)
	def testProcesoActualizacionEjecutadoPorElAdminErrorProcesoColeccionNula() {
		when(unServicioJSONmockeado.stringUpdateEspecie).thenReturn(jsonArrayEspecies.toString)
		when(unServicioJSONmockeado.stringUpdatePokeparada).thenReturn(jsonArrayPokeparadas.toString)
		when(unServicioJSONmockeado.stringUpdateUsuario).thenReturn(jsonArrayUsuarios.toString)
		procesoActualizacion.repositorios = null
		admin.ejecutarProceso(procesoActualizacion)
	}

	@Test
	def testProcesoAgregarAccionesEjecutadoPorElAdminAgrega() {
		admin.ejecutarProceso(procesoAgregarAcciones)
		Assert.assertEquals(3, ash.acciones.size)
	}

	@Test(expected=UserException)
	def testProcesoAgregarAccionesEjecutadoPorElAdminErrorAlAgregarAccionDuplicada() {
		ash.acciones.add(notificadorNivelMasAlto)
		admin.ejecutarProceso(procesoAgregarAcciones)
	}

	@Test(expected=UserException)
	def testProcesoAgregarAccionesEjecutadoPorElAdminErrorListaVacia() {
		procesoAgregarAcciones.acciones.clear
		admin.ejecutarProceso(procesoAgregarAcciones)
	}

	@Test(expected=UserException)
	def testProcesoAgregarAccionesEjecutadoPorElAdminErrorListaNula() {
		procesoAgregarAcciones.acciones = null
		admin.ejecutarProceso(procesoAgregarAcciones)
	}

	@Test(expected=UserException) // Arreglar
	def testProcesoEliminarAccionesEjecutadoPorElAdminElimina() {
		ash.acciones.add(notificadorSuperaAmigos)
		admin.ejecutarProceso(procesoEliminarAcciones)
		Assert.assertEquals(0, ash.acciones.size)
	}

	@Test(expected=UserException)
	def testProcesoEliminarAccionesEjecutadoPorElAdminErrorListaVacia() {
		ash.acciones.add(notificadorSuperaAmigos)
		procesoEliminarAcciones => [
			acciones.clear
		]
		admin.ejecutarProceso(procesoEliminarAcciones)
	}

	@Test(expected=UserException)
	def testProcesoEliminarAccionesEjecutadoPorElAdminErrorListaNula() {
		ash.acciones.add(notificadorSuperaAmigos)
		procesoEliminarAcciones => [
			acciones = null
		]
		admin.ejecutarProceso(procesoEliminarAcciones)
	}

	@Test(expected=UserException)
	def testProcesoEliminarAccionesEjecutadoPorElAdminErrorAlEliminarAccion() {
		procesoEliminarAcciones => []
		admin.ejecutarProceso(procesoEliminarAcciones)
	}

	@Test
	def testProcesoPoblarAreaEjecutadoPorElAdminPueblaUnArea() {
		admin.ejecutarProceso(procesoPoblarArea)
		Assert.assertEquals(2693, procesoPoblarArea.pokemonCreados.size)
	}

	@Test(expected=UserException)
	def testProcesoPoblarAreaEjecutadoPorElAdminErrorListaEspecieVacia() {
		procesoPoblarArea.especies.clear
		admin.ejecutarProceso(procesoPoblarArea)
	}

	@Test(expected=UserException)
	def testProcesoPoblarAreaEjecutadoPorElAdminErrorListaEspecieNula() {
		procesoPoblarArea.especies = null
		admin.ejecutarProceso(procesoPoblarArea)
	}

	@Test(expected=UserException)
	def testProcesoMultipleEjecutadoPorElAdminErrorProcesoVacio() {
		procesoMultiple.procesos.clear
		admin.ejecutarProceso(procesoMultiple)
	}

	@Test(expected=UserException)
	def testProcesoMultipleEjecutadoPorElAdminErrorProcesoNulo() {
		procesoMultiple.procesos = null
		admin.ejecutarProceso(procesoMultiple)
	}

	@Test(expected=BusinessException) // Arreglar
	def testProcesoMultipleEjecutadoPorElAdminFuncionaTodosLosProcesos() {
		when(unServicioJSONmockeado.stringUpdateEspecie).thenReturn(jsonArrayEspecies.toString)
		when(unServicioJSONmockeado.stringUpdatePokeparada).thenReturn(jsonArrayPokeparadas.toString)
		when(unServicioJSONmockeado.stringUpdateUsuario).thenReturn(jsonArrayUsuarios.toString)
		admin.ejecutarProceso(procesoMultiple)
		Assert.assertEquals(2, pokeparadas.pokeparadas.size)
		Assert.assertEquals(2, ash.acciones.size)
		Assert.assertEquals(2693, procesoPoblarArea.pokemonCreados.size)
	}
}

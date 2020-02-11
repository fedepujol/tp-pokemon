package Ar.edu.unsam.algo2.grupo8.TPPokemon

import Ar.edu.unsam.algo2.grupo8.domain.BusinessException
import Ar.edu.unsam.algo2.grupo8.domain.ServicioJSON
import Ar.edu.unsam.algo2.grupo8.factory.ItemFactory
import Ar.edu.unsam.algo2.grupo8.repos.RepositorioPokeparada
import net.sf.json.JSONArray
import net.sf.json.JSONException
import net.sf.json.JSONObject
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.uqbar.commons.model.exceptions.UserException

import static org.mockito.Mockito.*

class testJsonPokeparada {
	ServicioJSON servicioJSONMockeado = mock(ServicioJSON)
	RepositorioPokeparada repo1
	ItemFactory itemFactory
	JSONObject jsonPokeparada = new JSONObject
	JSONObject jsonPokeparada2 = new JSONObject
	JSONObject jsonPokeparada3 = new JSONObject
	JSONObject jsonPokeparada4 = new JSONObject
	JSONObject jsonPokeparada5 = new JSONObject
	JSONObject jsonPokeparada6 = new JSONObject
	JSONObject jsonPokeparada7 = new JSONObject
	JSONArray jsonInventario = new JSONArray
	JSONArray jsonArrayPokeparadas = new JSONArray

	@Before
	def void init() throws SecurityException, NoSuchFieldException, IllegalArgumentException, IllegalAccessException{
		repo1 = RepositorioPokeparada.instance
		itemFactory = ItemFactory.instance
		repo1.servicioJSON = servicioJSONMockeado
		jsonInventario.addAll("pokeball", "pocion")
		jsonPokeparada.accumulate("nombre", "Pokeparada Unsam").element("x", -34.1325).element("y", -34.124).accumulate(
			"itemsDisponibles", jsonInventario)

		jsonInventario.clear
		jsonInventario.addAll("superball", "superpocion")
		jsonPokeparada2.accumulate("nombre", "Pokeparada Olivos").element("x", -35.987).element("y", -33.654).
			accumulate("itemsDisponibles", jsonInventario)

		jsonInventario.clear
		jsonInventario.addAll("pokeball", "superball", "ultraball", "pocion", "superpocion")
		jsonPokeparada3.accumulate("nombre", "Pokeparada Saavedra").element("x", -35.987).element("y", -33.654).
			accumulate("itemsDisponibles", jsonInventario)

		jsonInventario.clear
		jsonInventario.addAll("ultraball", "pocion")
		jsonPokeparada4.accumulate("nombre", "").element("x", -34.987).element("y", -34.654).accumulate(
			"itemsDisponibles", jsonInventario)

		jsonInventario.clear
		jsonInventario.addAll("")
		jsonPokeparada5.accumulate("nombre", "Pokeparada Belgrano").element("x", -37.977).element("y", -35.654).
			accumulate("itemsDisponibles", jsonInventario)

		jsonInventario.clear
		jsonInventario.addAll("zinc", "combustible", "hiperpocion")
		jsonPokeparada6.accumulate("nombre", "Pokeparada Nuñez").element("x", -36.847).element("y", -36.100).accumulate(
			"itemsDisponibles", jsonInventario)

		jsonInventario.clear
		jsonInventario.add("cinc")
		jsonPokeparada7.accumulate("nombre", "Pokeparada Coghlan").element("x", -37.634).element("y", -37.203).accumulate(
			"itemsDisponibles", jsonInventario)
			
		jsonArrayPokeparadas.addAll(jsonPokeparada, jsonPokeparada2)
		var instance = repo1.class.getDeclaredField("instance")
		instance.setAccessible(true)
		instance.set(null, null)
	}

	@Test
	def testLeerYAgregarARepoVacio() {
		repo1.leerJson(jsonArrayPokeparadas)
		Assert.assertEquals(4, repo1.pokeparadas.size)
	}

	@Test
	def testUpdateDesdeUnJsonAUnaPokeparadaDelRepo() {
		repo1.leerJson(jsonArrayPokeparadas)
		repo1.crearObjeto(jsonPokeparada3)
		Assert.assertEquals(0, repo1.search("Olivos").size)
	}

	@Test(expected=BusinessException)
	def testCrearObjetoInvalidoDesdeUnJsonDaError() {
		repo1.crearObjeto(jsonPokeparada4)
	}

	@Test(expected=BusinessException)
	def testCrearObjetoDesdeUnJsonConInventarioVacioYDaError() {
		repo1.crearObjeto(jsonPokeparada5)
	}

	@Test(expected=UserException)
	def testServicioJSONDevuelveUnArrayVacioYDaError() {
		when(servicioJSONMockeado.stringUpdatePokeparada).thenReturn("")
		repo1.updateAll
	}

	@Test(expected=UserException)
	def testServicioJSONDevuelveNuloYDaError() {
		when(servicioJSONMockeado.stringUpdatePokeparada).thenReturn(null)
		repo1.updateAll
	}

	@Test
	def testServicioJSONDevuelveUnArrayValidoYSeCreanLosObjetos() {
		when(servicioJSONMockeado.stringUpdatePokeparada).thenReturn(jsonArrayPokeparadas.toString)
		repo1.updateAll
		Assert.assertEquals(4, repo1.pokeparadas.size)
	}

	@Test(expected=JSONException)
	def testServicioJSONDevuelveUnArrayInvalidoYDaError() {
		when(servicioJSONMockeado.stringUpdatePokeparada).thenReturn(jsonPokeparada4.toString)
		repo1.updateAll
	}

	@Test
	def testServicioJSONDevuelveUnArrayValidoYActualiza() {
		repo1.crearObjeto(jsonPokeparada3)
		when(servicioJSONMockeado.stringUpdatePokeparada).thenReturn(jsonArrayPokeparadas.toString)
		repo1.updateAll
		Assert.assertEquals(4, repo1.pokeparadas.size)
	}

	@Test
	def testCreacionDePokeparadaConIngredientes() {
		repo1.crearObjeto(jsonPokeparada6)
		Assert.assertEquals(3, repo1.pokeparadas.size)
	}

	@Test(expected=BusinessException)
	def testCreacionDePokeparadaConNombreDeIngredienteInvalidoDaError() {
		repo1.crearObjeto(jsonPokeparada7)
	}

}

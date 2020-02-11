package Ar.edu.unsam.algo2.grupo8.TPPokemon

import Ar.edu.unsam.algo2.grupo8.domain.BusinessException
import Ar.edu.unsam.algo2.grupo8.domain.Especie
import Ar.edu.unsam.algo2.grupo8.domain.EspecieSinEvolucion
import Ar.edu.unsam.algo2.grupo8.domain.ServicioJSON
import Ar.edu.unsam.algo2.grupo8.domain.Tipo
import Ar.edu.unsam.algo2.grupo8.repos.RepositorioEspecie
import Ar.edu.unsam.algo2.grupo8.repos.RepositorioTipo
import java.util.ArrayList
import java.util.Collection
import net.sf.json.JSONArray
import net.sf.json.JSONException
import net.sf.json.JSONObject
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.uqbar.commons.model.exceptions.UserException

import static org.mockito.Mockito.*

class testJsonEspecie {
	RepositorioEspecie repoEspecie
	RepositorioTipo repoTipo
	ServicioJSON servicioJsonMockeado = mock(ServicioJSON)
	JSONObject jsonEspecieBulbasor = new JSONObject
	JSONObject jsonEspecieBulbasor2 = new JSONObject
	JSONObject jsonEspecieInvalida = new JSONObject
	JSONObject jsonEspecieIvysaur = new JSONObject
	JSONObject jsonEspecieVenasaur = new JSONObject
	JSONObject jsonEspecieRattata = new JSONObject
	JSONArray jsonArrayEspecies = new JSONArray 
	JSONObject jsonEspecieOnix = new JSONObject
	Collection<Tipo> tiposOnix = new ArrayList<Tipo>
		
	@Before
	def void init() throws SecurityException, NoSuchFieldException, IllegalArgumentException, IllegalAccessException{
		repoTipo = RepositorioTipo.instance
		repoEspecie = RepositorioEspecie.instance
		repoEspecie.servicioJSON = servicioJsonMockeado
		repoEspecie.especies.clear
		
		tiposOnix.add(repoTipo.search("Acero").get(0))
		jsonEspecieVenasaur.element("numero", 3)
					.element("nombre", "Venasaur")
					.element("puntosAtaqueBase", 10)
					.element("puntosSaludBase", 352) 
					.element("descripcion", "A Venasaur es fácil verle echándose una siesta")  
					.accumulate("tipos", "hierba")
					.accumulate("tipos", "veneno")
					.element("velocidad", 17)					
			
		jsonEspecieIvysaur.element("numero", 2)
					.element("nombre", "Ivysaur")
					.element("puntosAtaqueBase", 15)
					.element("puntosSaludBase", 20) 
					.element("descripcion", "Este Pokémon lleva un bulbo en el lomo.")  
					.accumulate("tipos", "hierba")
					.accumulate("tipos", "veneno")
					.element("velocidad", 8)
					.element("evolucion", 3)
					.element("nivelEvolucion", 32)
					
		jsonEspecieBulbasor.element("numero", 1)
					.element("nombre", "Bulbasaur")
					.element("puntosAtaqueBase", 10)
					.element("puntosSaludBase", 15) 
					.element("descripcion", "A Bulbasaur es fácil verle echándose una siesta al sol.")  
					.accumulate("tipos", "hierba")
					.accumulate("tipos", "veneno")
					.element("velocidad", 7)
					.element("evolucion", 2)
					.element("nivelEvolucion", 16)
		
		jsonEspecieRattata.element("numero", 19)
					.element("nombre", "Rattata")
					.element("puntosAtaqueBase", 10)
					.element("puntosSaludBase", 15) 
					.element("descripcion", "A Rattata le gusta morder.")
					.accumulate("tipos", "normal")
					.accumulate("tipos", "tierra")
					.element("velocidad", 7)
					.element("evolucion", 20)
					.element("nivelEvolucion", 20)
		
		jsonEspecieOnix.element("numero", 7)
					.element("nombre", "Onix")
					.element("puntosAtaqueBase", 10)
					.element("puntosSaludBase", 15) 
					.element("descripcion", "A Squirtle le gusta nadar.")
					.accumulate("tipos", "agua")
					.accumulate("tipos", "hielo")
					.element("velocidad", 7)
					
		jsonEspecieInvalida.element("numero", 7)
					.element("nombre", "")
					.element("puntosAtaqueBase", 10)
					.element("puntosSaludBase", 15) 
					.element("descripcion", "A Squirtle le gusta nadar.")
					.accumulate("tipos", "agua")
					.accumulate("tipos", "hielo")
					.element("velocidad", 7)
						
		jsonEspecieBulbasor2.element("numero", 1)
					.element("nombre", "Bulbasor")
					.element("puntosAtaqueBase", 10031)
					.element("puntosSaludBase", 15000) 
					.element("descripcion", "Bulbasor es lo mas.")
					.accumulate("tipos", "agua")
					.accumulate("tipos", "hielo")
					.element("velocidad", 7)
														
		jsonArrayEspecies.addAll(jsonEspecieVenasaur, jsonEspecieIvysaur, jsonEspecieBulbasor)
		var instance = repoEspecie.class.getDeclaredField("instance")
		instance.setAccessible(true)
		instance.set(null, null)		
	}
		
	@Test(expected=BusinessException)//Arreglar
	def testJsonLeerYAgregarARepoVacio(){
		repoEspecie.leerJson(jsonArrayEspecies)
		Assert.assertEquals(3, repoEspecie.especies.size)
	}
	
	@Test
	def testJsonCrearEspecieConEvolucion(){
		var Especie Raticate = new EspecieSinEvolucion("Raticate","descripcion",15,1000,0,20,{})
		repoEspecie.especies.add(Raticate)
		repoEspecie.crearObjeto(jsonEspecieRattata)
		Assert.assertEquals("Rattata", repoEspecie.search("Rattata").get(0).nombre)
	}
	
	@Test
	def testJsonCrearEspecieSinEvolucion(){
		repoEspecie.crearObjeto(jsonEspecieOnix)
		Assert.assertEquals(0, repoEspecie.search("Onix").get(0).nivelEvolutivo)
	}
	
	@Test(expected=BusinessException)
	def void testJsonExcepcionCuandoSeQuiereAgregarUnPokemonYNoSeEncuentraSuEvolucion(){
		repoEspecie.crearObjeto(jsonEspecieRattata)
	}
	
	@Test(expected=BusinessException)
	def testJsonUpdateEspecieQueExisteEnRepoPeroSinIDTiraException(){
		var Especie Venasaur = new EspecieSinEvolucion("Venasaur","descripcion",15,1000,10,3,tiposOnix)
		repoEspecie.leerJson(jsonArrayEspecies)
		repoEspecie.agregarOUpdate(Venasaur)	
	}
	
	@Test(expected=BusinessException)//Arreglar
	def testJsonCrearEspecieQueNoExisteEnRepo(){
		var Especie Onix = new EspecieSinEvolucion("Onix","descripcion",15,1000,10,52,tiposOnix)
		repoEspecie.leerJson(jsonArrayEspecies)
		repoEspecie.agregarOUpdate(Onix)
		Assert.assertEquals(1, repoEspecie.search("Onix").size)
	
	}
	
	@Test(expected=BusinessException)
	def testJsonUpdateEspecieNoValida(){
		var Especie Venasaur = new EspecieSinEvolucion("Venasaur","descripcion",15,0,10,3,tiposOnix)
		repoEspecie.leerJson(jsonArrayEspecies)
		Venasaur.identificadorEspecie = repoEspecie.especies.get(0).identificadorEspecie
		repoEspecie.agregarOUpdate(Venasaur)
	}
	
	@Test(expected=BusinessException)
	def testJsonUpdateEspecieQueNoEstaEnRepositorio(){
		var Especie Onix = new EspecieSinEvolucion("Onix","descripcion",15,1000,10,52,tiposOnix)
		repoEspecie.leerJson(jsonArrayEspecies)
		repoEspecie.update(Onix)
	}

	@Test(expected=UserException)
	def testServicioJSONDevuelveUnArrayVacioYDaError() {
		when(servicioJsonMockeado.stringUpdateEspecie).thenReturn("")
		repoEspecie.updateAll
	}

	@Test(expected=UserException)
	def testServicioJSONDevuelveNuloYDaError() {
		when(servicioJsonMockeado.stringUpdateEspecie).thenReturn(null)
		repoEspecie.updateAll
	}

	@Test(expected=BusinessException)//Arreglar
	def testServicioJSONDevuelveUnArrayValidoYSeCreanLosObjetos() {
		when(servicioJsonMockeado.stringUpdateEspecie).thenReturn(jsonArrayEspecies.toString)
		repoEspecie.updateAll
		Assert.assertEquals(3, repoEspecie.especies.size)
	}

	@Test(expected=JSONException)
	def testServicioJSONDevuelveUnArrayInvalidoYDaError() {
		when(servicioJsonMockeado.stringUpdateEspecie).thenReturn(jsonEspecieInvalida.toString)
		repoEspecie.updateAll
	}

	@Test(expected=BusinessException)//Arreglar
	def testServicioJSONDevuelveUnArrayValidoYActualiza() {
		repoEspecie.crearObjeto(jsonEspecieBulbasor2)
		when(servicioJsonMockeado.stringUpdateEspecie).thenReturn(jsonArrayEspecies.toString)
		repoEspecie.updateAll
		Assert.assertEquals(3, repoEspecie.especies.size)
	}
		
}


package Ar.edu.unsam.algo2.grupo8.TPPokemon

import Ar.edu.unsam.algo2.grupo8.domain.BusinessException
import Ar.edu.unsam.algo2.grupo8.domain.Especie
import Ar.edu.unsam.algo2.grupo8.repos.RepositorioEspecie
import org.junit.Assert
import org.junit.Before
import org.junit.Test

class testRepoEspecie {

	RepositorioEspecie repo1
	Especie especiePikachu
	Especie especieSquirtle

	@Before
	def void init() throws SecurityException, NoSuchFieldException, IllegalArgumentException, IllegalAccessException{
		repo1 = RepositorioEspecie.instance
		
		especiePikachu = repo1.search("Pikachu").get(0)
		especieSquirtle = repo1.search("Squirtle").get(0)
		
		var instance = repo1.class.getDeclaredField("instance")
		instance.setAccessible(true)
		instance.set(null, null)
	}

	@Test
	def testCrearUnaEspecieValida() {
		Assert.assertEquals(true, repo1.especies.contains(especiePikachu))
	}

	@Test(expected=BusinessException)
	def testAlCrearEspecieInvalidaTiraExcepcion() {
		repo1.delete(especieSquirtle)
		especieSquirtle.puntoAtaqueBase = -2
		repo1.create(especieSquirtle)
	}

	@Test(expected=BusinessException)
	def testUpdateUnaEspecieQueNoEstaEnELRepoDevuelveExcepcion() {
		repo1.delete(especiePikachu)
		repo1.update(especiePikachu)
	}

	@Test(expected=BusinessException)
	def testUpdateConUnaEspecieinvalidaDevuelveExcepcion() {
		especieSquirtle.puntoAtaqueBase = -2
		repo1.update(especieSquirtle)
	}

	@Test
	def testupdateUnaEspecie() {
		especieSquirtle.identificadorEspecie = especiePikachu.identificadorEspecie
		repo1.update(especieSquirtle)
		Assert.assertEquals(300, repo1.especies.get(0).puntoSaludBase)
	}

	@Test // Arreglar
	def testSearchPorNumeroDeEspecieDevuelveLaEspecieDeEseNumero() {
		var Especie especieAux = repo1.search("Snorlax").get(0)
		Assert.assertEquals("Snorlax", repo1.searchById(especieAux.identificadorEspecie).nombre)
	}

	@Test
	def testPorNumeroQueNoCoincideDevuelveListaVacia() {
		Assert.assertEquals(0, repo1.search("222").size)
	}

	@Test
	def testSearchPorNombreDevuelveColeccionConEspecieSquirtle() {
		Assert.assertEquals("Squirtle", repo1.search("squ").get(0).nombre)
	}

	@Test
	def testSearchPorNombreQueNoCoincideDevuelveColeccionVacia() {
		Assert.assertEquals(0, repo1.search("carlitos").size)
	}

	@Test
	def testSearchPorDescripcionDeEspecieSquirtleDevuelveColeccionConEspecieSquirtle() {
		Assert.assertEquals("Squirtle", repo1.search("Squirtle").get(0).nombre)
	}

	@Test
	def testSearchPorDescripcionQueNoCoincideDevuelveColeccionVacia() {
		Assert.assertEquals(0, repo1.search("es un guacho").size)
	}

	@Test
	def testDeleteUnaEspecieQueEstaEnElRepo() {
		repo1.delete(especiePikachu)
		Assert.assertEquals(false, repo1.especies.contains(especiePikachu))
	}

	@Test(expected=BusinessException)
	def testDeleteUnaEspecieQueNoExistenteEnElRepo() {
		repo1.delete(especiePikachu)
		repo1.delete(especiePikachu)
	}

	@Test
	def testSearchByIdUnaEspecieExistenteEnElRepo() {
		Assert.assertEquals("Bellsprout", repo1.searchById(2).nombre)
	}

	@Test
	def testSearchByIdUnaEspecieQueNoExistenteEnElRepo() {
		repo1.delete(especieSquirtle)
		Assert.assertEquals(null, repo1.searchById(especieSquirtle.identificadorEspecie))
	}

}

package Ar.edu.unsam.algo2.grupo8.TPPokemon

import Ar.edu.unsam.algo2.grupo8.domain.BusinessException
import Ar.edu.unsam.algo2.grupo8.domain.Item
import Ar.edu.unsam.algo2.grupo8.domain.Pokeball
import Ar.edu.unsam.algo2.grupo8.domain.Pokeparada
import Ar.edu.unsam.algo2.grupo8.repos.RepositorioPokeparada
import java.util.ArrayList
import java.util.Collection
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.uqbar.geodds.Point

class testRepoPokeparada {

	RepositorioPokeparada repo1
	Pokeparada pokeparadaUnsam
	Point coordenada
	Collection<Item> itemsPokeparada = new ArrayList<Item>
	Item pokebola

	@Before
	def void init() throws SecurityException, NoSuchFieldException, IllegalArgumentException, IllegalAccessException{
		repo1 = RepositorioPokeparada.instance
		pokebola = new Pokeball("Pokebola", 80, 1)
		itemsPokeparada.add(pokebola)
		coordenada = new Point(-34.579580, -58.526357)
		pokeparadaUnsam = new Pokeparada("Pokeparada Unsam", coordenada, itemsPokeparada)
		var instance = repo1.class.getDeclaredField("instance")
		instance.setAccessible(true)
		instance.set(null, null)
		repo1.create(pokeparadaUnsam)
	}

	@Test
	def testSearchPorNombreQueNoCoincideDevuelveColeccionVacia() {
		Assert.assertEquals(0, repo1.search("pokeparada Untref").size)
	}

	@Test
	def testSearchPorItemsDevuelveCollecionConPokeparadaConElItemBuscado() {
		Assert.assertEquals("Pokeparada Unsam", repo1.search("Pokebola").get(0).nombre)
	}

	@Test
	def testSearchPorItemsDevuelveCollecionVacia() {
		Assert.assertEquals(0, repo1.search("falsaball").size)

	}

	@Test(expected=BusinessException)
	def testIntentoDeCreacionDePokeparadaSinNombreResultaEnErrorPokeparadaInvalida() {
		repo1.create(new Pokeparada("", new Point(-35.23, -35.364), itemsPokeparada))
	}

	@Test
	def testCreacionDePokeparadaSinInventario() {
		repo1.create(new Pokeparada("Pokeparada Saavedra", new Point(-35.23, -35.364), {
		}))
		Assert.assertEquals("Pokeparada Saavedra", repo1.search("Saavedra").get(0).nombre)
	}

	@Test(expected=BusinessException)
	def testUpdateDeUnaPokeparadaQueNoEstaEnElRepo() {
		repo1.create(pokeparadaUnsam)
		repo1.update(new Pokeparada("Pokeparada Saavedra", new Point(-35.23, -35.364),
			itemsPokeparada))

	}

	@Test
	def testUpdateUnaPokeparadaExistenteEnElRepo() {
		var Pokeparada pokeparadaNueva = new Pokeparada("Pokeparada Saavedra", new Point(-34.579580, -58.526357),
			itemsPokeparada)
		pokeparadaNueva.id = pokeparadaUnsam.id
		repo1.update(pokeparadaNueva)
		Assert.assertEquals(0, repo1.search("Unsam").size)
	}

	@Test
	def testDeleteUnaPokeparadaExistenteEnElRepo() {
		repo1.delete(pokeparadaUnsam)
		Assert.assertEquals(2, repo1.pokeparadas.size)
	}

	@Test(expected=BusinessException)
	def testDeleteUnaPokeparadaQueNoExistenteEnElRepo() {
		repo1.delete(pokeparadaUnsam)
		repo1.delete(pokeparadaUnsam)
	}

	@Test
	def testSearchByIdUnaPokeparadaExistenteEnElRepo() {
		Assert.assertEquals("UNSAM", repo1.searchById(1).nombre)
	}

	@Test
	def testSearchByIdUnaPokeparadaQueNoExistenteEnElRepo() {
		repo1.delete(pokeparadaUnsam)
		Assert.assertEquals(2, repo1.pokeparadas.size)
	}
	
}

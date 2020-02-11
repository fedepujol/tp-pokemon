package Ar.edu.unsam.algo2.grupo8.TPPokemon

import Ar.edu.unsam.algo2.grupo8.domain.BusinessException
import Ar.edu.unsam.algo2.grupo8.domain.Entrenador
import Ar.edu.unsam.algo2.grupo8.domain.Especie
import Ar.edu.unsam.algo2.grupo8.domain.EspecieConEvolucion
import Ar.edu.unsam.algo2.grupo8.domain.EspecieSinEvolucion
import Ar.edu.unsam.algo2.grupo8.domain.Luchador
import Ar.edu.unsam.algo2.grupo8.domain.PerfilEntrenador
import Ar.edu.unsam.algo2.grupo8.domain.Pokemon
import Ar.edu.unsam.algo2.grupo8.domain.Tipo
import Ar.edu.unsam.algo2.grupo8.repos.RepositorioTipo
import java.util.ArrayList
import java.util.Collection
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.uqbar.geodds.Point

class testEspecie {

	RepositorioTipo repoTipo

	Collection<Tipo> tiposRattata = new ArrayList<Tipo>
	Collection<Tipo> tiposSquirtle = new ArrayList<Tipo>
	Collection<Tipo> tiposOnix = new ArrayList<Tipo>
	Collection<Tipo> tiposVacios = new ArrayList<Tipo>

	Point coordenada = new Point(-34.579580, -58.526357)
	PerfilEntrenador luchador = new Luchador()
	Entrenador ash = new Entrenador("Ash", luchador, coordenada, 300)

	Especie especieWartortle
	Especie especieOnix
	Especie especieSquirtle

	Pokemon onix
	Pokemon squirtle

	@Before
	def void init() throws SecurityException, NoSuchFieldException, IllegalArgumentException, IllegalAccessException{
		repoTipo = RepositorioTipo.instance

		tiposRattata.add(repoTipo.search("Electrico").get(0))
		tiposSquirtle.add(repoTipo.search("Agua").get(0))
		tiposOnix.add(repoTipo.search("Acero").get(0))

		especieWartortle = new EspecieConEvolucion("Wartortle", "Es hermoso", 50, 40, 50, 36, 3, null, tiposSquirtle)
		especieSquirtle = new EspecieConEvolucion("Squirtle", "Vamo a calmarno", 10, 20, 10, 16, 2, especieWartortle,
			tiposSquirtle)
		especieOnix = new EspecieSinEvolucion("Onix", "Descripcion", 100, 200, 10, 52, tiposOnix)

		onix = new Pokemon(especieOnix, coordenada, "macho")
		squirtle = new Pokemon(especieSquirtle, coordenada, "macho")

		var instance = repoTipo.class.getDeclaredField("instance")
		instance.setAccessible(true)
		instance.set(null, null)
	}

	@Test
	def especieSinValoresVaciosEsValida() {
		Assert.assertTrue(especieOnix.esValida())
	}

	@Test
	def especieConSalud0NoEsValida() {
		var Especie Rattata = new EspecieSinEvolucion("Rattata", "descripcion", 100, 0, 10, 52, tiposRattata)
		Assert.assertFalse(Rattata.esValida())
	}

	@Test
	def especieFlatTiposResistentes() {
		Assert.assertEquals(3, especieOnix.tiposResistentes().size)
	}

	@Test
	def especieFlatTiposFuertes() {
		Assert.assertEquals(3, especieOnix.tiposFuertes().size)
	}

	@Test(expected=BusinessException)
	def void especieFlatTiposFuertesConTiposNulos() {
		var Especie Rattata = new EspecieSinEvolucion("Rattata", "descripcion", 100, 0, 10, 52, tiposVacios)
		Rattata.tiposFuertes()
	}

	@Test
	def especieSinEvolucionEvolucionaA() {
		Assert.assertEquals(especieOnix, especieOnix.evolucionaA(onix, ash))
	}

	@Test
	def especieConEvolucionEvolucionaA() {
		especieSquirtle.nivelEvolutivo = 1
		Assert.assertEquals(especieWartortle, especieSquirtle.evolucionaA(squirtle, ash))
	}
}

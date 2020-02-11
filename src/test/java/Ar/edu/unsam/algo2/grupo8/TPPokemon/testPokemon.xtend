package Ar.edu.unsam.algo2.grupo8.TPPokemon

import Ar.edu.unsam.algo2.grupo8.domain.Entrenador
import Ar.edu.unsam.algo2.grupo8.domain.Especie
import Ar.edu.unsam.algo2.grupo8.domain.EspecieConEvolucion
import Ar.edu.unsam.algo2.grupo8.domain.Luchador
import Ar.edu.unsam.algo2.grupo8.domain.PerfilEntrenador
import Ar.edu.unsam.algo2.grupo8.domain.Pokemon
import Ar.edu.unsam.algo2.grupo8.domain.Tipo
import java.util.ArrayList
import java.util.Collection
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.uqbar.geodds.Point

class testPokemon {
	Especie especiePikachu
	Especie especieSquirtle
	Especie especieWartortle
	Entrenador ash
	PerfilEntrenador luchador = new Luchador()
	Pokemon pikachu
	Pokemon squirtle
	Point coordenada
	Point coordenada2
	Tipo electrico
	Tipo agua = new Tipo("agua", null, null)
	Tipo volador = new Tipo("volador", null, null)
	Tipo acero = new Tipo("acero", null, null)
	Collection<Tipo> tiposPikachu = new ArrayList<Tipo>
	Collection<Tipo> tiposSquirtle = new ArrayList<Tipo>
	Collection<Tipo> fuertesElectrico = new ArrayList<Tipo>
	Collection<Tipo> resistentesElectrico = new ArrayList<Tipo>

	@Before
	def void init() {
		agua = new Tipo("agua", null, null)
		volador = new Tipo("volador", null, null)
		acero = new Tipo("acero", null, null)
		fuertesElectrico.addAll(agua,volador)
		resistentesElectrico.addAll(volador,acero)
		electrico = new Tipo("electrico", fuertesElectrico, resistentesElectrico)
		resistentesElectrico.add(electrico)
		tiposPikachu.add(electrico)
		tiposSquirtle.add(agua)
		especieWartortle = new EspecieConEvolucion("wartortle", "es hermoso", 50, 40, 50, 36, 3, null, tiposSquirtle)
		especiePikachu = new EspecieConEvolucion("pikachu", "pika pika", 10, 20, 10, 16, 1,  null, tiposPikachu)
		especieSquirtle = new EspecieConEvolucion("squirtle", "vamo a calmarno", 10, 20, 10, 16, 2, especieWartortle, tiposSquirtle)
		coordenada = new Point(-34.579580, -58.526357)
		coordenada2 = new Point(-34.581261, -58.516434)
		ash = new Entrenador("Ash Ketchum", luchador, coordenada, 45.15)
		pikachu = new Pokemon(especiePikachu, coordenada, "Macho")
		squirtle = new Pokemon(especieSquirtle, coordenada2, "Hembra")
	}

	@Test
	def testPokemonExperiencia0Nivel1() {
		Assert.assertEquals(1, pikachu.nivel)
	}

	@Test
	def testPokemonExperiencia175Nivel2() {
		pikachu.experiencia = 175
		Assert.assertEquals(2, pikachu.nivel)
	}

	@Test
	def testPokemonNivel2Ataque20() {
		pikachu.experiencia = 175
		Assert.assertEquals(20, pikachu.puntosDeAtaque)
	}

	@Test
	def testPokemonNivel2SaludMaxima40() {
		pikachu.experiencia = 175
		Assert.assertEquals(40, pikachu.puntosDeSaludMaxima)
	}

	@Test
	def testPokemonDistanciaAPunto() {
		Assert.assertEquals(0.94074, pikachu.distanciaRespectoAUnPunto(coordenada2), 0.1)

	}

	@Test
	def unPokemonEsFuerteContraOtro() {
		Assert.assertEquals(true, pikachu.esFuerteA(squirtle))

	}

	@Test
	def unPokemonEsResistenteAOtro() {
		Assert.assertEquals(true, pikachu.esResistenteA(pikachu))

	}

	@Test
	def unPokemonEvoluciona() {
		// para llegar a nivel 16 debe sumar 12000 de experiencia
		squirtle.experiencia = 11900
		pikachu.experiencia = 1100
		squirtle.sumarExperiencia(pikachu, ash)
		Assert.assertEquals(true, squirtle.especie == especieWartortle)
	}

	@Test
	def chancesDeEscaparIgualA2() {
		Assert.assertEquals(2, pikachu.chancesEscapar)

	}

	@Test
	def chancesDeGanarBatallaIgualA22() {
		// Entrenador Experto
		ash.experiencia = 185001
		ash.batallasGanadas = 31
		fuertesElectrico.clear
		Assert.assertEquals(22d, pikachu.chancesDeGanarBatalla(ash, squirtle), 0.01)

	}

	@Test
	def chancesDeGanarBatallaIgualA34Coma5() {
		// Entrenador Experto y pokemon que es fuerte vs el rival
		ash.experiencia = 185001
		ash.batallasGanadas = 31
		Assert.assertEquals(34.5d, pikachu.chancesDeGanarBatalla(ash, squirtle), 0.01)

	}

	@Test
	def chancesDeGanarBatallaIgualA46() {
		// Entrenador Experto y pokemon que es fuerte y resistente vs el rival
		ash.experiencia = 185001
		ash.batallasGanadas = 31
		resistentesElectrico.add(agua)
		Assert.assertEquals(46d, pikachu.chancesDeGanarBatalla(ash, squirtle), 0.01)
	}

	
}

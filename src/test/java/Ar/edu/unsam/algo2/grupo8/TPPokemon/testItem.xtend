package Ar.edu.unsam.algo2.grupo8.TPPokemon

import Ar.edu.unsam.algo2.grupo8.domain.BusinessException
import Ar.edu.unsam.algo2.grupo8.domain.Especie
import Ar.edu.unsam.algo2.grupo8.domain.EspecieSinEvolucion
import Ar.edu.unsam.algo2.grupo8.domain.HiperPocion
import Ar.edu.unsam.algo2.grupo8.domain.IngredientePorcentaje
import Ar.edu.unsam.algo2.grupo8.domain.IngredientePorcentajePorTipo
import Ar.edu.unsam.algo2.grupo8.domain.IngredientePuntosFijos
import Ar.edu.unsam.algo2.grupo8.domain.Pocion
import Ar.edu.unsam.algo2.grupo8.domain.Pokemon
import Ar.edu.unsam.algo2.grupo8.domain.Tipo
import java.util.ArrayList
import java.util.Collection
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.uqbar.geodds.Point

class testItem {
	Pocion pocion = new Pocion("Pocion", 50, 20)
	
	Tipo agua = new Tipo("agua", null, null)
	Tipo hierba = new Tipo("hierba", null, null)
	Collection<Tipo> tiposPikachu = new ArrayList<Tipo>
	Collection<Tipo> tiposSquirtle = new ArrayList<Tipo>
	Especie Onix = new EspecieSinEvolucion("Onix", "Descripcion", 100, 200, 10, 52, tiposPikachu)
	Especie Mew = new EspecieSinEvolucion("Onix", "Descripcion", 100, 200, 10, 52, tiposSquirtle)
	Point coordenada = new Point(-34.579580, -58.526357) 
	Pokemon unOnix = new Pokemon(Onix, coordenada, "macho" )
	Pokemon unMew = new Pokemon(Mew, coordenada, "macho" )
	HiperPocion unaHiperPocion = new HiperPocion("HiperPocion")
	
	@Before
	def void init(){
		tiposPikachu.add(hierba)
		tiposSquirtle.add(agua)
	}
	
	@Test
	def pokemonLastimadoSeCuraConPocionLlegandoA50DeVida(){
		unOnix.puntosDeSaludActual=0
		pocion.curarPokemon(unOnix)
		Assert.assertEquals(20, unOnix.puntosDeSaludActual)
	}
	
	
	@Test(expected=BusinessException)
	def void pokemonConSaludAlMaximoTiraExcepcionAlCurar(){
		pocion.curarPokemon(unOnix)
	}
	
	@Test 
	def pokemonSeCuraSinPasarseDelMaximo(){
		unOnix.puntosDeSaludActual = unOnix.puntosDeSaludMaxima - 5
		pocion.curarPokemon(unOnix)
		Assert.assertEquals(unOnix.puntosDeSaludMaxima, unOnix.puntosDeSaludActual)
	}
	
	@Test 
	def pokemonSeLeSumaCiertaCantidadDeSalud(){
		unOnix.puntosDeSaludActual=0
		pocion.sumarSalud(unOnix, 20)
		Assert.assertEquals(20, unOnix.puntosDeSaludActual)
	}
	
	@Test
	def pocionDecoradaConHierroSumaSaludTotalde25(){
		var IngredientePuntosFijos hierro = new IngredientePuntosFijos("Hierro", 10, 5)  //Cambio new porque ya no recibe un quimico decorado. Para que siga dando bien le seteo el decorado abajo.
		hierro.decorado = pocion
		unOnix.puntosDeSaludActual=0
		hierro.curarPokemon(unOnix)
		Assert.assertEquals(25, unOnix.puntosDeSaludActual)
	}
	
	@Test
	def pocionDecoradaConZincSumaSaludTotal26(){
		var IngredientePorcentaje zinc = new IngredientePorcentaje("Zinc", 15, 30) //Cambio new porque ya no recibe un quimico decorado. Para que siga dando bien le seteo el decorado abajo.
		zinc.decorado = pocion
		unOnix.puntosDeSaludActual=0
		zinc.curarPokemon(unOnix)
		Assert.assertEquals(26, unOnix.puntosDeSaludActual)
	}
	
	@Test
	def pocionDecoradaConFertilizanteCuraAPokemonHierba30(){
		var IngredientePorcentajePorTipo fertilizante = new IngredientePorcentajePorTipo("Fertilizante", 40, 20, hierba, 50) //Cambio new porque ya no recibe un quimico decorado. Para que siga dando bien le seteo el decorado abajo.
		fertilizante.decorado = pocion
		unOnix.puntosDeSaludActual=0
		fertilizante.curarPokemon(unOnix)
		Assert.assertEquals(30, unOnix.puntosDeSaludActual)
	}
	
	@Test 
	def pocionDecoradaConFertilizanteCuraAPokemonNoHierba24(){
		var IngredientePorcentajePorTipo fertilizante = new IngredientePorcentajePorTipo("Fertilizante", 40, 20, hierba, 50) //Cambio new porque ya no recibe un quimico decorado. Para que siga dando bien le seteo el decorado abajo.
		fertilizante.decorado = pocion		
		unMew.puntosDeSaludActual=0
		fertilizante.curarPokemon(unMew)
		Assert.assertEquals(24, unMew.puntosDeSaludActual)
	}

	@Test 
	def pocionDecoradaConFertilizanteYZincYHierroCuraAPokemonNoHierba44(){
		var IngredientePorcentajePorTipo fertilizante = new IngredientePorcentajePorTipo("Fertilizante", 40, 20, hierba, 50) //Cambio new porque ya no recibe un quimico decorado. Para que siga dando bien seteo los decorados abajo.
		var IngredientePorcentaje zinc = new IngredientePorcentaje("Zinc", 15, 30)
		var IngredientePuntosFijos hierro = new IngredientePuntosFijos("Hierro", 10, 5)
		fertilizante.decorado = pocion
		zinc.decorado = fertilizante
		hierro.decorado = zinc
		unOnix.puntosDeSaludActual=0
		hierro.curarPokemon(unOnix)
		Assert.assertEquals(44, unOnix.puntosDeSaludActual)
	}
	
	@Test 
	def pocionDecoradaConHierroYFertilizanteYZincCuraAPokemonNoHierba48(){
		var IngredientePuntosFijos hierro = new IngredientePuntosFijos("Hierro", 10, 5)
		var IngredientePorcentajePorTipo fertilizante = new IngredientePorcentajePorTipo("Fertilizante", 40, 20, hierba, 50) //Cambio new porque ya no recibe un quimico decorado. Para que siga dando bien seteo los decorados abajo.
		var IngredientePorcentaje zinc = new IngredientePorcentaje("Zinc", 15, 30)
		fertilizante.decorado = hierro
		zinc.decorado = fertilizante
		hierro.decorado = pocion
		unOnix.puntosDeSaludActual=0
		zinc.curarPokemon(unOnix)
		Assert.assertEquals(48, unOnix.puntosDeSaludActual)

	}
	
	@Test
	def hiperPocionCuraAPokemonDelTodo(){
		unOnix.puntosDeSaludActual=0
		unaHiperPocion.curarPokemon(unOnix)
		Assert.assertEquals(unOnix.puntosDeSaludMaxima, unOnix.puntosDeSaludActual)
	}
}



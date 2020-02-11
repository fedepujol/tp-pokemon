package Ar.edu.unsam.algo2.grupo8.TPPokemon

import Ar.edu.unsam.algo2.grupo8.domain.BusinessException
import Ar.edu.unsam.algo2.grupo8.domain.Coleccionista
import Ar.edu.unsam.algo2.grupo8.domain.Criador
import Ar.edu.unsam.algo2.grupo8.domain.Entrenador
import Ar.edu.unsam.algo2.grupo8.domain.Especie
import Ar.edu.unsam.algo2.grupo8.domain.EspecieConEvolucion
import Ar.edu.unsam.algo2.grupo8.domain.Ingrediente
import Ar.edu.unsam.algo2.grupo8.domain.IngredientePorcentaje
import Ar.edu.unsam.algo2.grupo8.domain.IngredientePorcentajePorTipo
import Ar.edu.unsam.algo2.grupo8.domain.IngredientePuntosFijos
import Ar.edu.unsam.algo2.grupo8.domain.Item
import Ar.edu.unsam.algo2.grupo8.domain.Luchador
import Ar.edu.unsam.algo2.grupo8.domain.NotificadorNivelMasAlto
import Ar.edu.unsam.algo2.grupo8.domain.NotificadorNivelMultiploDe5
import Ar.edu.unsam.algo2.grupo8.domain.NotificadorSuperaAmigos
import Ar.edu.unsam.algo2.grupo8.domain.PerfilEntrenador
import Ar.edu.unsam.algo2.grupo8.domain.Pocion
import Ar.edu.unsam.algo2.grupo8.domain.Pokeball
import Ar.edu.unsam.algo2.grupo8.domain.Pokemon
import Ar.edu.unsam.algo2.grupo8.domain.Pokeparada
import Ar.edu.unsam.algo2.grupo8.domain.Randomize
import Ar.edu.unsam.algo2.grupo8.domain.Recompensa
import Ar.edu.unsam.algo2.grupo8.domain.Tipo
import Ar.edu.unsam.algo2.grupo8.repos.RepositorioTipo
import Ar.edu.unsam.algo2.grupo8.sender.Mail
import Ar.edu.unsam.algo2.grupo8.sender.MessageSender
import Ar.edu.unsam.algo2.grupo8.sender.StubMailSender
import java.util.ArrayList
import java.util.Collection
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.uqbar.geodds.Point

import static org.mockito.ArgumentMatchers.*
import static org.mockito.Mockito.*

class testEntrenador {

	RepositorioTipo repoTipo
	Especie especiePikachu
	Especie especieSquirtle
	Ingrediente hierro = new IngredientePuntosFijos("hierro", 10, 5)
	Ingrediente zinc = new IngredientePorcentaje("zinc", 15, 30)
	Ingrediente cobre
	Pokeball pokebola = new Pokeball("Pokebola", 80, 1)
	Pocion pocion = new Pocion("Pocion", 20, 10)
	Pokemon pikachu
	Pokemon squirtle
	Point coordenada
	Point coordenada2
	Point coordenada3
	Tipo electrico
	Randomize randomMockeado = mock(Randomize)
	Entrenador ash
	Entrenador npc
	Pokeparada pokeparadaUnsam
	PerfilEntrenador luchador = new Luchador()
	PerfilEntrenador coleccionista = new Coleccionista()
	PerfilEntrenador criador = new Criador()
	Collection<Tipo> tiposPikachu = new ArrayList<Tipo>
	Collection<Tipo> tiposSquirtle = new ArrayList<Tipo>
	Collection<Item> itemsPokeparada = new ArrayList<Item>
	MessageSender mockedMailSender
	StubMailSender stubMailSender
	NotificadorSuperaAmigos notificadorSuperaAmigos
	NotificadorNivelMasAlto notificadorNivelMasAlto
	NotificadorNivelMultiploDe5 notificadorNivelMultiploDe5
	Recompensa recompensa

	@Before
	def void init() throws SecurityException, NoSuchFieldException, IllegalArgumentException, IllegalAccessException{
		repoTipo = RepositorioTipo.instance
		itemsPokeparada.add(pokebola)

//		Init Tipos
		electrico = repoTipo.search("Electrico").get(0)
		tiposPikachu.add(electrico)
		tiposSquirtle.add(repoTipo.search("Agua").get(0))
//		Fin init Tipos

//		Init Especies
		especiePikachu = new EspecieConEvolucion("pikachu", "Esta loco", 10, 200, 10, 16, 1, null, tiposPikachu)
		especieSquirtle = new EspecieConEvolucion("squirtle", "Vamo a calmarno", 10, 25, 10, 16, 2, null, tiposSquirtle)
//		Fin init Especies

//		Init coordenadas
		coordenada = new Point(-34.579580, -58.526357)
		coordenada2 = new Point(-34.581261, -58.516434)
		coordenada3 = new Point(22.581261, 33.516434)
//		Fin init coordenadas

//		Init Pokemon
		pikachu = new Pokemon(especiePikachu, coordenada, "Macho")
		squirtle = new Pokemon(especieSquirtle, coordenada2, "Hembra")
//		Fin init Pokemon

		cobre = new IngredientePorcentajePorTipo("zinc", 15, 20, electrico, 50)
		pokeparadaUnsam = new Pokeparada("pokeparada UNSAM", coordenada, itemsPokeparada)
		mockedMailSender = mock(typeof(MessageSender))
		stubMailSender = new StubMailSender
		notificadorSuperaAmigos = new NotificadorSuperaAmigos(stubMailSender, "Superaste a un amigo")
		notificadorNivelMasAlto = new NotificadorNivelMasAlto(stubMailSender, "Llegaste al nivel mas alto")
		notificadorNivelMultiploDe5 = new NotificadorNivelMultiploDe5("Recompensa 5x")
		recompensa = new Recompensa(5, 5000, itemsPokeparada, "Recompensa")

//		Init Entrenadores
		npc = new Entrenador("Gary", luchador, coordenada, 250)
		ash = new Entrenador("Ash Ketchum", luchador, coordenada, 500)
		ash.random = randomMockeado
		ash.inventario.put(pokebola, 3)
		ash.inventario.put(pocion, 2)
		ash.inventario.put(hierro, 2)
		ash.inventario.put(zinc, 2)
		ash.inventario.put(cobre, 2)
		ash.acciones.add(notificadorNivelMultiploDe5)
		ash.acciones.add(notificadorSuperaAmigos)
		ash.acciones.add(notificadorNivelMasAlto)
		ash.acciones.add(recompensa)

		var instance = repoTipo.class.getDeclaredField("instance")
		instance.setAccessible(true)
		instance.set(null, null)
	}

	@Test
	def entrenadorSinExperienciaEsNivel1() {
		ash.nivel.agregarNivel(1, 0)
		Assert.assertEquals(1, ash.nivelActual())
	}

	@Test
	def entrenadorCon3001DeExperienciaEsNivel3() {
		ash.nivel.agregarNivel(3, 3000)
		ash.nivel.agregarNivel(4, 6000)
		ash.experiencia = 3001
		Assert.assertEquals(3, ash.nivelActual())
	}

	@Test
	def entrenadorLuchadorExpertoPorTenerNivelMayorA18() {
		ash.nivel.agregarNivel(19, 185000)
		ash.nivel.agregarNivel(20, 210000)
		ash.experiencia = 185001
		Assert.assertEquals(true, ash.esExperto)
	}

	@Test
	def entrenadorLuchadorExpertoPorTenerMasDe30BatallasGanadas() {
		ash.nivel.agregarNivel(1, 0)
		ash.batallasGanadas = 31
		Assert.assertEquals(true, ash.esExperto)
	}

	@Test
	def entrenadorLuchadorNoEsExperto() {
		ash.nivel.agregarNivel(18, 160000)
		ash.nivel.agregarNivel(19, 185000)
		ash.experiencia = 160000
		ash.batallasGanadas = 30
		Assert.assertEquals(false, ash.esExperto())
	}

	@Test
	def entrenadorColeccionistaQueNoEsExperto() {
		ash.nivel.agregarNivel(1, 0)
		ash.perfil = coleccionista
		Assert.assertEquals(false, ash.esExperto())
	}

	@Test
	def entrenadorCriadorEsExperto() {
		ash.nivel.agregarNivel(17, 140000)
		ash.nivel.agregarNivel(18, 160000)
		ash.perfil = criador
		ash.pokemonesEvolucionados = 15
		pikachu.experiencia = 150000
		ash.depositoPokemones.addAll(pikachu, pikachu, pikachu, pikachu, pikachu, pikachu)
		Assert.assertEquals(true, ash.esExperto)
	}

	@Test
	def entrenadorCriadorNoEsExperto() {
		ash.nivel.agregarNivel(1, 0)
		ash.perfil = criador
		Assert.assertEquals(false, ash.esExperto())
	}

	@Test
	def especiesDistintasAtrapadasDevuelve0() {
		Assert.assertEquals(0, ash.cantidadDeEspeciesDistintasAtrapadas)
	}

	@Test
	def especiesDistintasAtrapadasDevuelve2() {
		ash.aniadirEspecie(especiePikachu)
		ash.aniadirEspecie(especieSquirtle)
		Assert.assertEquals(2, ash.cantidadDeEspeciesDistintasAtrapadas)
	}

	@Test(expected=BusinessException)
	def void testSiNoTienePokemonesAtrapadosMachosSobreElTotalTiraExcepcion() {
		ash.machosSobreElTotal
	}

	@Test
	def coleccionBalanceada() {
		ash.depositoPokemones.addAll(pikachu, squirtle)
		Assert.assertEquals(true, ash.coleccionBalanceada)

	}

	@Test
	def coleccionDesbalanceada() {
		ash.depositoPokemones.addAll(pikachu, squirtle, pikachu)
		Assert.assertEquals(false, ash.coleccionBalanceada)

	}

	@Test
	def cantidadDePokemonesConNivelMayorA2Devuelve1() {
		ash.depositoPokemones.addAll(pikachu, squirtle)
		pikachu.experiencia = 200 // con 200 de experiencia el nivel da 2
		squirtle.experiencia = 600 // con 600 de experiencia el nivel da mas de 2
		Assert.assertEquals(1, ash.cantidadPokemonesConNivelMayorA(2))
	}

	@Test
	def cantidadDePokemonesAtrapadosDevuelve2() {
		ash.depositoPokemones.addAll(pikachu, squirtle)
		Assert.assertEquals(2, ash.cantidadPokemonesAtrapados)
	}

	@Test
	def moverseAUnPunto() {
		ash.moverseA(coordenada3, pokeparadaUnsam)
		Assert.assertEquals(coordenada3, ash.ubicacion)
	}

	@Test(expected=BusinessException)
	def void intentarAtraparAunPokemonQueEstaMuyLejos() {
		ash.ubicacion = coordenada3
		ash.intentarAtraparA(pikachu, pokebola)
	}

	@Test
	def entrenadorAccedeAPokeparada() {
		ash.accederAPokeparada(pokeparadaUnsam)
		Assert.assertEquals(true, pokeparadaUnsam.entrenadores.contains(ash))
	}

	@Test(expected=BusinessException)
	def void entrenadorNoPuedeAccederAPokeparadaPorEstarLejos() {
		ash.ubicacion = coordenada3
		ash.accederAPokeparada(pokeparadaUnsam)
	}

	@Test
	def entrenadorAbandonaPokeparada() {
		ash.accederAPokeparada(pokeparadaUnsam)
		ash.abandonarPokeparada(pokeparadaUnsam)
		Assert.assertEquals(false, pokeparadaUnsam.entrenadores.contains(ash))
	}

	@Test
	def curarEquipo() {
		ash.equipo.addAll(pikachu, squirtle)
		ash.accederAPokeparada(pokeparadaUnsam)
		pikachu.puntosDeSaludActual = pikachu.puntosDeSaludActual - 5
		ash.curarEquipo(pokeparadaUnsam)
		Assert.assertEquals(pikachu.puntosDeSaludMaxima, pikachu.puntosDeSaludActual)
	}

	@Test
	def entrenadorCompra10PokebolasYLeBaja800ElDinero() {
		ash.dinero = 1000
		ash.accederAPokeparada(pokeparadaUnsam)
		ash.comprarItem(pokeparadaUnsam, pokebola, 10)
		Assert.assertEquals(200, ash.dinero, 0.01)
	}

	@Test
	def entrenadorCompraUnaPokebola() {
		ash.dinero = 1000
		ash.accederAPokeparada(pokeparadaUnsam)
		ash.comprarItem(pokeparadaUnsam, pokebola, 1)
		Assert.assertEquals(true, ash.inventario.keySet.contains(pokebola))
	}

	@Test(expected=BusinessException)
	def void entrenadorNoPuedeComprar10PokebolasPorFaltaDeDinero() {
		ash.dinero = 100
		ash.accederAPokeparada(pokeparadaUnsam)
		ash.comprarItem(pokeparadaUnsam, pokebola, 10)
	}

	@Test(expected=BusinessException)
	def void entrenadorNoPuedeGuardarPokemonPorSerElUnicoDelEquipo() {
		ash.accederAPokeparada(pokeparadaUnsam)
		ash.equipo.add(pikachu)
		pokeparadaUnsam.cambioDePokemonEquipoADeposito(ash, pikachu)
	}

	@Test
	def entrenadorGuardaPokemonEnELDeposito() {
		ash.accederAPokeparada(pokeparadaUnsam)
		ash.equipo.addAll(pikachu, squirtle)
		ash.ponerPokemonDelEquipoEnElDeposito(pikachu)
		Assert.assertEquals(true, ash.estaEnElDeposito(pikachu))
	}

	@Test
	def entrenadorSacaPokemonDelDeposito() {
		ash.accederAPokeparada(pokeparadaUnsam)
		ash.depositoPokemones.add(pikachu)
		ash.ponerPokemonDelDepositoEnElEquipo(pikachu)
		Assert.assertEquals(false, ash.estaEnElDeposito(pikachu))
	}

	@Test
	def enfrentamientoGanaElPokemonDelEntrenador() {
		when(randomMockeado.aplicarRandom).thenReturn(0.0)
		Assert.assertTrue(ash.ganoBatalla(pikachu, squirtle, npc, 200d))
	}

	@Test
	def enfrentamientoPierdeElPokemonDelEntrenador() {
		when(randomMockeado.aplicarRandom).thenReturn(1.0)
		Assert.assertEquals(false, ash.ganoBatalla(pikachu, squirtle, npc, 200d))
	}

	@Test
	def entrenadorIntentaAtraparAUnPokemonYLoLogra() {
		when(randomMockeado.aplicarRandom).thenReturn(0.0)
		ash.intentarAtraparA(pikachu, pokebola)
		Assert.assertEquals(1, ash.equipo.size)
	}

	@Test
	def entrenadorIntentaAtraparAUnPokemonYLoNoLogra() {
		when(randomMockeado.aplicarRandom).thenReturn(1.0)
		ash.intentarAtraparA(pikachu, pokebola)
		Assert.assertEquals(0, ash.equipo.size)
	}

	@Test(expected=BusinessException)
	def void entrenadorCuraAPokemonQueNoTieneYTiraExcepcion() {
		ash.curarPokemon(pikachu, pocion)
	}

	@Test(expected=BusinessException)
	def void entrenadorCuraAPokemonConUnaPocionQueNoTieneTiraExcepcion() {
		ash.equipo.add(pikachu)
		ash.curarPokemon(pikachu, pocion)
	}

	@Test(expected=BusinessException)
	def void entrenadorCuraAPokemonConUnaPocionQueTieneCantidad0YTiraExcepcion() {
		ash.equipo.add(pikachu)
		ash.inventario.put(pocion, 0)
		ash.curarPokemon(pikachu, pocion)
	}

	@Test
	def void entrenadorCuraAPokemon() {
		// La pocion cura 10 puntos
		pikachu.puntosDeSaludActual = 0
		ash.equipo.add(pikachu)
		ash.inventario.put(pocion, 4)
		ash.curarPokemon(pikachu, pocion)
		Assert.assertEquals(10, pikachu.puntosDeSaludActual)
	}

	@Test
	def void entrenadorCuraAPokemonYLeResta1PocionDelInventario() {
		pikachu.puntosDeSaludActual = 0
		ash.equipo.add(pikachu)
		ash.inventario.put(pocion, 4)
		ash.curarPokemon(pikachu, pocion)
		Assert.assertEquals(3, ash.inventario.get(pocion))
	}

	@Test
	def void testCurarPokemonConPocionCustom() {
		/* la pocion cura 10 puntos.
		 * 		pocion + hierro = 15 puntos.
		 * 		pocion + hierro + zinc = 19 puntos.
		 pocion + hierro + zinc + cobre = 28 puntos.*/
		var Ingrediente pocionCustom
		pikachu.puntosDeSaludActual = 0
		ash.equipo.add(pikachu)
		pocionCustom = ash.prepararPocionCustom(pocion, hierro)
		pocionCustom = ash.prepararPocionCustom(pocionCustom, zinc)
		pocionCustom = ash.prepararPocionCustom(pocionCustom, cobre)
		ash.curarPokemon(pikachu, pocionCustom)

		Assert.assertEquals(pikachu.puntosDeSaludActual, 28)
	}

	@Test(expected=BusinessException)
	def void testEntrenadorNoPuedeDecorarUnaPocionPorNoSerParteDelInventario() {
		ash.inventario.remove(pocion)
		ash.prepararPocionCustom(pocion, hierro)

	}

	@Test(expected=BusinessException)
	def void testEntrenadorNoPuedeDecorarUnaPocionPorqueNoLeQuedanMasEnElInventario() {
		ash.inventario.put(pocion, 0)
		ash.prepararPocionCustom(pocion, hierro)

	}

	@Test(expected=BusinessException)
	def void testNoPuedeDecorarConIngredientePorNoSerParteDelInventario() {
		ash.inventario.remove(hierro)
		ash.prepararPocionCustom(pocion, hierro)
	}

	@Test(expected=BusinessException)
	def void testNoPuedeDecorarUnaPocionPorQueNoLeQuedanMasDelIngredienteAUsar() {
		ash.inventario.put(hierro, 0)
		ash.prepararPocionCustom(pocion, hierro)

	}

	@Test
	def void testAlDecorarConUnIngredienteNoSeModificaElDelInventario() {
		var Ingrediente pocionCustom
		pocionCustom = ash.prepararPocionCustom(pocion, hierro)
		Assert.assertEquals(hierro.decorado == pocion, false)
	}

	@Test
	def void testEntrenadorSubeDeNivelYSeEnvian2Mails() {
		ash.nivel.agregarNivel(1, 0)
		ash.nivel.agregarNivel(2, 1000)
		ash.nivel.agregarNivel(3, 2000)
		ash.listaAmigos.add(npc)
		Assert.assertEquals(0, stubMailSender.mailsDe("pokemonalgo@gmail.com").size)
		ash.sumarExperiencia(1001)
		Assert.assertEquals(0, stubMailSender.mailsDe("pokemonalgo@gmail.com").size)
	}

	@Test
	def void testEntrenadorSubeDeNivelYSeEnvia2VecesUnMailY3VecesOtro() {
		ash.nivel.agregarNivel(1, 0)
		ash.nivel.agregarNivel(2, 1000)
		notificadorSuperaAmigos.messageSender = mockedMailSender
		notificadorNivelMasAlto.messageSender = mockedMailSender
		ash.listaAmigos.add(npc)
		ash.listaAmigos.add(npc)
		ash.sumarExperiencia(1001)
		verify(mockedMailSender, times(5)).send(any(typeof(Mail)))
	}

	@Test
	def void testEntrenadorSubeDeNivelPeroNoSeEnviaNingunMail() {
		notificadorSuperaAmigos.messageSender = mockedMailSender
		notificadorNivelMasAlto.messageSender = mockedMailSender
		ash.nivel.agregarNivel(1, 0)
		ash.nivel.agregarNivel(2, 1000)
		ash.nivel.agregarNivel(3, 3000)
		npc.nivel.agregarNivel(1, 0)
		npc.nivel.agregarNivel(2, 1000)
		npc.nivel.agregarNivel(3, 3000)
		ash.listaAmigos.add(npc)
		npc.experiencia = 3001
		ash.sumarExperiencia(1001)
		verify(mockedMailSender, never).send(any(Mail))
	}

	@Test
	def void testEntrenadorSinAccionesSubeDeNivelYNoPasaNada() {
		ash.nivel.agregarNivel(1, 0)
		ash.nivel.agregarNivel(2, 1000)
		ash.acciones.remove(notificadorNivelMultiploDe5)
		ash.acciones.remove(notificadorSuperaAmigos)
		ash.acciones.remove(notificadorNivelMasAlto)
		ash.acciones.remove(recompensa)
		ash.listaAmigos.add(npc)
		Assert.assertEquals(0, stubMailSender.mailsDe("pokemonalgo@gmail.com").size)
		ash.sumarExperiencia(1001)
		Assert.assertEquals(0, stubMailSender.mailsDe("pokemonalgo@gmail.com").size)
	}

	@Test
	def void testEntrenadorSubeDeNivelYRecibe1NotificacionPorLlegarAlNivelMasAlto() {
		ash.nivel.agregarNivel(1, 0)
		ash.nivel.agregarNivel(2, 1000)
		ash.listaAmigos.add(npc)
		ash.sumarExperiencia(1001)
		Assert.assertEquals(ash.nombre + " alcanzo el nivel mas alto", ash.notificaciones.get(0))
	}

	@Test
	def void testEntrenadorSubeDeNivelYRecibe1NotificacionPorAlcanzarNivelMultiploDe5() {
		ash.nivel.agregarNivel(4, 6000)
		ash.nivel.agregarNivel(5, 10000)
		ash.listaAmigos.add(npc)
		ash.sumarExperiencia(10001)
		Assert.assertEquals("Ash Ketchum ha subido a un nivel multiplo de 5", ash.notificaciones.get(0))
	}

	@Test
	def void testEntrenadorSubeDeNivelYAmigosRecibenNotificacionPorQueEsMultiploDe5() {
		ash.nivel.agregarNivel(4, 6000)
		ash.nivel.agregarNivel(5, 10000)
		ash.listaAmigos.add(npc)
		ash.sumarExperiencia(10001)
		Assert.assertEquals("Ash Ketchum ha subido a un nivel multiplo de 5", npc.notificaciones.get(0))
	}

	@Test
	def void testEntrenadorsubeDeNivelYRecibeRecompensa() {
		ash.nivel.agregarNivel(1, 0)
		ash.nivel.agregarNivel(2, 1000)
		ash.nivel.agregarNivel(4, 6000)
		ash.nivel.agregarNivel(5, 10000)
		ash.inventario.put(pokebola, 0)
		ash.dinero = 0
		ash.listaAmigos.add(npc)
		ash.sumarExperiencia(10001)
		Assert.assertEquals(5000, ash.dinero, 0.001)
		Assert.assertEquals(1, ash.inventario.get(pokebola))
	}
}

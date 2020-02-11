package Ar.edu.unsam.algo2.grupo8.TPPokemon

import Ar.edu.unsam.algo2.grupo8.domain.BusinessException
import Ar.edu.unsam.algo2.grupo8.domain.Entrenador
import Ar.edu.unsam.algo2.grupo8.domain.Luchador
import Ar.edu.unsam.algo2.grupo8.domain.PerfilEntrenador
import Ar.edu.unsam.algo2.grupo8.domain.Randomize
import Ar.edu.unsam.algo2.grupo8.domain.SolicitudAmistad
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.uqbar.geodds.Point

import static org.mockito.Mockito.*

class testAmistad {

	Randomize randomMockeado = mock(Randomize)
	Entrenador ash
	Entrenador npc
	PerfilEntrenador luchador = new Luchador()
	Point coordenada
	
	@Before
	def void init() {
	coordenada = new Point(-34.579580, -58.526357)
	ash = new Entrenador("Ash Ketchum", luchador, coordenada, 200)
	npc = new Entrenador("Gary", luchador, coordenada, 35.54)
	}
	
	@Test(expected=BusinessException)
	def void testNoSePuedeEnviarLaSolicitudPorQueYaSonAmigos() {
		ash.listaAmigos.add(npc)
		ash.enviarSolicitudA(npc)
	}

	@Test
	def void testSeEnviaUnaSolicitudDeAmistadYSeAgregaALaListaDePendientesDelReceptor() {
		ash.enviarSolicitudA(npc)
		Assert.assertEquals(1, npc.solicitudesPendientes.size())
	}

	@Test(expected=BusinessException)
	def void testLaSolicitudRecibidaNoEstaPendiente() {
		var unaSolicitud = new SolicitudAmistad(ash, npc)
		ash.aceptarORechazar(unaSolicitud)
	}

	@Test
	def void testSeRechazaLaSolicitudEntoncesSeBorraDeLosPendientesDelReceptor() {
		var unaSolicitud = new SolicitudAmistad(ash, npc)
		npc.solicitudesPendientes.add(unaSolicitud)
		when(randomMockeado.aplicarRandom).thenReturn(1.0)
		npc.aceptarORechazar(unaSolicitud)
		Assert.assertEquals(0, npc.solicitudesPendientes.size())
	}

	@Test
	def void testSeAceptaLaSolicitudEntoncesSeBorraDeLosPendientesDelReceptor() {
		var unaSolicitud = new SolicitudAmistad(ash, npc)
		npc.solicitudesPendientes.add(unaSolicitud)
		when(randomMockeado.aplicarRandom).thenReturn(0.0)
		npc.aceptarORechazar(unaSolicitud)
		Assert.assertEquals(0, npc.solicitudesPendientes.size())
	}

	@Test
	def void testSeAceptaLaSolicitudEntoncesSeAgregaComoAmigoDelReceptor() {
		var unaSolicitud = new SolicitudAmistad(ash, npc)
		npc.solicitudesPendientes.add(unaSolicitud)
		when(randomMockeado.aplicarRandom).thenReturn(0.0)
		npc.aceptarORechazar(unaSolicitud)
		Assert.assertTrue(npc.listaAmigos.contains(ash))
	}

	@Test
	def void testSeAceptaLaSolicitudEntoncesSeAgregaComoAmigoDelEmisor() {
		when(randomMockeado.aplicarRandom).thenReturn(0.0)
		var unaSolicitud = new SolicitudAmistad(ash, npc)
		npc.solicitudesPendientes.add(unaSolicitud)
		npc.aceptarORechazar(unaSolicitud)
		Assert.assertTrue(ash.listaAmigos.contains(npc))
	}

	@Test(expected=BusinessException)
	def void testNoSePuedeEliminarUnAmigoQueNoEstaEntreLosAmigos() {
		ash.eliminarAmigo(npc)
	}

	@Test
	def void testSeEliminaElAmigoDelListadoDelReceptor() {
		ash.listaAmigos.add(npc)
		ash.eliminarAmigo(npc)
		Assert.assertTrue(!ash.listaAmigos.contains(npc))
	}

	@Test
	def void testSeEliminaElAmigoDelListadoDelEmisor() {
		ash.listaAmigos.add(npc)
		ash.eliminarAmigo(npc)
		Assert.assertTrue(!npc.listaAmigos.contains(ash))
	}

	
}
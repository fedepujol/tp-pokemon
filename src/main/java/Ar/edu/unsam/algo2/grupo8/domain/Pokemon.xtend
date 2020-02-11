package Ar.edu.unsam.algo2.grupo8.domain

import java.util.ArrayList
import java.util.Collection
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.geodds.Point

@Accessors
class Pokemon {

	int experiencia = 1
	int puntosDeSaludActual
	int idRepo
	int idPokemon
	Especie especie
	Point ubicacion
	String genero
	String nombrePokemon

	new(Especie unaEspecie, Point unaUbicacion, String unGenero) {
		nombrePokemon = unaEspecie.nombre
		especie = unaEspecie
		ubicacion = unaUbicacion
		genero = unGenero
		puntosDeSaludActual = puntosDeSaludMaxima
	}

	def puntosDeAtaque() {
		nivel * especie.puntoAtaqueBase
	}

	def getPuntosDeSaludMaxima() {
		nivel * especie.puntoSaludBase
	}

	def getNivel() {
		((Math.sqrt(100 * (2 * experiencia + 25)) + 50) / 100).intValue
	}

	def double distanciaRespectoAUnPunto(Point punto) {
		ubicacion.distance(punto)
	}

	def void evolucionar(Entrenador unEntrenador) {
		especie = especie.evolucionaA(this, unEntrenador)
	}

	def tiposFuertes() {
		especie.tiposFuertes.toList
	}

	def tiposResistentes() {
		especie.tiposResistentes.toList
	}

	def Collection<Tipo> tipos() {
		especie.tipos
	}

	def esFuerteA(Pokemon unPokemon) {
		val List<Tipo> aux = new ArrayList<Tipo> 
		unPokemon.tipos.forEach[tipo|checkTipos(tipo, aux, tiposFuertes)]
		aux.size > 0
	}

	def checkTipos(Tipo unTipo, List<Tipo> unaLista, Collection<Tipo> unosTipos){
		unaLista.addAll(unosTipos.filter[tipo|tipo.nombre.contains(unTipo.nombre)].toList)
	}

	def esResistenteA(Pokemon unPokemon) {
		val List<Tipo> aux = new ArrayList<Tipo>
		unPokemon.tipos.forEach[tipo|checkTipos(tipo, aux, tiposResistentes)]
		aux.size > 0
	}

	def chancesEscapar() {
		nivel * (1 + especie.velocidad / 10)
	}

	def double chancesDeGanarBatalla(Entrenador unEntrenador, Pokemon unPokemon) {
		var double chances
		chances = puntosDeAtaque.doubleValue

		if (unEntrenador.esExperto()) {
			chances += calcularChance(0.20)
		}
		if (esFuerteA(unPokemon)) {
			chances += calcularChance(0.25)
		}
		if (esResistenteA(unPokemon)) {
			chances += calcularChance(0.15)
		}

		chances
	}

	def double calcularChance(double unValor) {
		puntosDeAtaque * (1 + unValor)
	}

	def sumarExperiencia(Pokemon unPokemon, Entrenador unEntrenador) {
		experiencia += (unPokemon.experiencia * 50.5).intValue
		evolucionar(unEntrenador)
	}

	def recibirDanio(Pokemon unPokemon) {
		puntosDeSaludActual -= calcularDanio(unPokemon)
	}

	def calcularDanio(Pokemon unPokemon) {
		puntosDeSaludMaxima * (puntosDeAtaque / (puntosDeAtaque + unPokemon.puntosDeAtaque))
	}

	def quedarKO() {
		puntosDeSaludActual = 0
	}

	def restaurarSalud() {
		puntosDeSaludActual = puntosDeSaludMaxima
	}

	def calcularExperienciaParaNivel(int unNivel) {
		(((((unNivel * 100) - 50) * ((unNivel * 100) - 50)) / 100) - 25) / 2
	}

	def esValido() {
		especie !== null && genero != ""
	}

	def cambiarNombrePokemon(String unNombre) {
		nombrePokemon = unNombre
	}
}

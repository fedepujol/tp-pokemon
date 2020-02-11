package Ar.edu.unsam.algo2.grupo8.domain

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
abstract class PerfilEntrenador {
	String nombre
	
	def boolean esExperto(Entrenador unEntrenador)

	def int experienciaPorCapturaNuevaEspecie() {
		100
	}

	def int experienciaPorBatallaGanada() {
		300
	}

	def double experienciaPorEvolucion(int unaExperiencia) {
		200
	}
}

class Luchador extends PerfilEntrenador {

	new(){
		nombre = "Luchador"	
	}
	
	override boolean esExperto(Entrenador unEntrenador) {
		(unEntrenador.nivelActual() > 18) || (unEntrenador.batallasGanadas > 30)
	}

	override experienciaPorBatallaGanada() {
		super.experienciaPorBatallaGanada + 200
	}

}

class Coleccionista extends PerfilEntrenador {

	new(){
		nombre = "Coleccionista"	
	}

	override boolean esExperto(Entrenador unEntrenador) {
		(unEntrenador.nivelActual() > 13) && (unEntrenador.cantidadDeEspeciesDistintasAtrapadas() > 20) &&
			(unEntrenador.coleccionBalanceada())
	}

	override experienciaPorCapturaNuevaEspecie() {
		super.experienciaPorCapturaNuevaEspecie + 500
	}

}

class Criador extends PerfilEntrenador {

	new(){
		nombre = "Criador"	
	}

	override boolean esExperto(Entrenador unEntrenador) {
		(unEntrenador.pokemonesEvolucionados > 14) && (unEntrenador.cantidadPokemonesConNivelMayorA(20) > 5)
	}

	override experienciaPorEvolucion(int unaExperiencia) {
		var double experiencia
		experiencia = super.experienciaPorEvolucion(unaExperiencia)+ 200 + unaExperiencia * 0.2
	}
}

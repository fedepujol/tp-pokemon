package Ar.edu.unsam.algo2.grupo8.domain

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
abstract class Item {
	Integer id
	var double valor
	var String nombre

	new() {
	}

	new(String unNombre, double unValor) {
		nombre = unNombre
		valor = unValor
	}

	def double utilizar()

}

@Accessors
class Pokeball extends Item {
	var double chances

	new(String unNombre, double unValor, double unasChances) {
		super(unNombre, unValor)
		chances = unasChances
	}

	override utilizar() {
		chances
	}

}

@Accessors
abstract class Quimico extends Item {
	var int puntosCuracion

	new() {
	}

	new(String unNombre, double unValor, int unosPuntosCuracion) {
		super(unNombre, unValor)
		puntosCuracion = unosPuntosCuracion
	}

	def curarPokemon(Pokemon unPokemon) {
		if (unPokemon.puntosDeSaludActual.equals(unPokemon.puntosDeSaludMaxima)) {
			throw new BusinessException("Los puntos de saludo del pokemon estan al maximo")
		}
		if (saludCuradaExcedeSaludMaxima(unPokemon)) {
			sumarSalud(unPokemon, unPokemon.puntosDeSaludMaxima - unPokemon.puntosDeSaludActual)
		} else {
			sumarSalud(unPokemon, this.utilizarQuimico(unPokemon).intValue)
		}
	}

	def sumarSalud(Pokemon unPokemon, int unNumero) {
		unPokemon.puntosDeSaludActual = unPokemon.puntosDeSaludActual + unNumero
	}

	def saludCuradaExcedeSaludMaxima(Pokemon unPokemon) {
		(unPokemon.puntosDeSaludActual + this.utilizarQuimico(unPokemon).intValue) > unPokemon.puntosDeSaludMaxima
	}

	override utilizar() {
		0
	}

	def utilizarQuimico(Pokemon unPokemon) {
		puntosCuracion
	}
}

class Pocion extends Quimico {

	new(String unNombre, double unValor, int unosPuntosCuracion) {
		super(unNombre, unValor, unosPuntosCuracion)
	}

}

class HiperPocion extends Item {

	new() {
	}

	new(String unNombre) {
		super(unNombre, 150)
	}

	def curarPokemon(Pokemon unPokemon) {
		if (unPokemon.puntosDeSaludActual.equals(unPokemon.puntosDeSaludMaxima)) {
			throw new BusinessException("Los puntos de saludo del pokemon estan al maximo")
		}
		sumarSalud(unPokemon, unPokemon.puntosDeSaludMaxima)
	}

	def sumarSalud(Pokemon unPokemon, int unNumero) {
		unPokemon.puntosDeSaludActual = unNumero
	}

	override utilizar() {
		0
	}

}

@Accessors
abstract class Ingrediente extends Quimico implements Cloneable { //Implementa cloneable asi puede llamar a super.clone
	var Quimico decorado

	new() {
	}

	new(String unNombre, double unValor) {
		nombre = unNombre
		valor = unValor
	}

	// Agrego metodo clone asi se puede clonar el ingrediente
	override Ingrediente clone() {
		try {
			super.clone() as Ingrediente
		} catch (CloneNotSupportedException e) {
			throw new BusinessException("El ingrediente no es clonable")
		}

	}

}

class IngredientePuntosFijos extends Ingrediente {
	var int puntosCuracion

	new(String unNombre, double unValor, int unosPuntosCuracion) { // Aca no recibe mas un quimico decorado
		super(unNombre, unValor)
		puntosCuracion = unosPuntosCuracion
	}

	override utilizarQuimico(Pokemon unPokemon) {
		decorado.utilizarQuimico(unPokemon) + puntosCuracion
	}

}

class IngredientePorcentaje extends Ingrediente {
	var double porcentajeCuracion

	new(String unNombre, double unValor, double unPorcentaje) {

		super(unNombre, unValor)
		porcentajeCuracion = unPorcentaje / 100
	}

	override utilizarQuimico(Pokemon unPokemon) {
		(decorado.utilizarQuimico(unPokemon) * (1 + porcentajeCuracion)).intValue
	}

}

class IngredientePorcentajePorTipo extends Ingrediente {
	var double porcentajeEstandarCuracion
	var Tipo tipoAlQueBeneficia
	var double porcentajeTipo

	new(String unNombre, double unValor, double unPorcentajeEstandar, Tipo unTipo, double unPorcentajeTipo) {

		super(unNombre, unValor)
		porcentajeEstandarCuracion = unPorcentajeEstandar / 100
		porcentajeTipo = unPorcentajeTipo / 100
		tipoAlQueBeneficia = unTipo
	}

	override utilizarQuimico(Pokemon unPokemon) {
		if (!unPokemon.especie.tipos.contains(tipoAlQueBeneficia)) {
			return (decorado.utilizarQuimico(unPokemon) * (1 + porcentajeEstandarCuracion)).intValue
		}
		return (decorado.utilizarQuimico(unPokemon) * (1 + porcentajeTipo)).intValue

	}
}

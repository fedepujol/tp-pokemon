package Ar.edu.unsam.algo2.grupo8.domain

import com.fasterxml.jackson.annotation.JsonIgnore
import java.util.ArrayList
import java.util.Collection
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.commons.model.annotations.Observable

@Accessors
@Observable
abstract class Especie {
	
	String nombre
	@JsonIgnore String descripcion
	int puntoAtaqueBase
	int puntoSaludBase
	@JsonIgnore int velocidad
	@JsonIgnore int numeroEspecie
	@JsonIgnore int identificadorEspecie
	@JsonIgnore int nivelEvolutivo=0
	@JsonIgnore Especie evolucion
	Collection<Tipo> tipos = new ArrayList<Tipo> // Listado de tipos de la especie

	new(String unaEspecie, String unaDescripcion, int ataqueBase, int saludBase, int unaVelocidad, int unNumero, Collection<Tipo> unosTipos) {
		numeroEspecie = unNumero
		nombre = unaEspecie
		descripcion = unaDescripcion
		puntoAtaqueBase = ataqueBase
		puntoSaludBase = saludBase
		velocidad = unaVelocidad
		tipos = unosTipos
	}

	def Especie evolucionaA(Pokemon unPokemon, Entrenador unEntrenador)

	def Iterable<Tipo> tiposFuertes() {
		val List<Tipo> tipoFuerteAux = new ArrayList<Tipo>
		revisarTipos()
		tipos.forEach[tipo|this.agregarTiposFuertes(tipo, tipoFuerteAux)]
		tipoFuerteAux
	}
	
	def agregarTiposFuertes(Tipo unTipo, Collection<Tipo> unaColeccion){
		unTipo.tiposFuertes.forEach[tipo|unaColeccion.add(tipo)]
	}

	def Iterable<Tipo> tiposResistentes() {
		val List<Tipo> tipoResistenteAux = new ArrayList<Tipo>
		revisarTipos()
		tipos.forEach[tipo|this.agregarTiposResistentes(tipo, tipoResistenteAux)]
		tipoResistenteAux
	}
	
	def agregarTiposResistentes(Tipo unTipo, Collection<Tipo> unaColeccion){
		unTipo.tiposResistentes.forEach[tipo|unaColeccion.add(tipo)]
	}	
	def esValida(){
		(puntoAtaqueBase > 0 && puntoSaludBase > 0 && !nombre.empty && numeroEspecie > 0 && !descripcion.empty
			 && velocidad > 0) //&& !tipos.empty
	}
	
		
	def revisarTipos(){
		if(tipos.empty){
			throw new BusinessException("No Tiene Tipos")
		}
	}

}

class EspecieSinEvolucion extends Especie {

	new(String unaEspecie, String unaDescripcion, int ataqueBase, int saludBase, int unaVelocidad, int unNumeroEspecie, Collection<Tipo> unosTipos) {
		super(unaEspecie, unaDescripcion, ataqueBase, saludBase, unaVelocidad, unNumeroEspecie, unosTipos)
	}

	override def Especie evolucionaA(Pokemon unPokemon, Entrenador unEntrenador) {
		this
	}

}

class EspecieConEvolucion extends Especie {

	//int nivelEvolutivo // Nivel al que necesita llegar para evolucionar
//	Especie evolucion // Especie a la que evoluciona


	new(String unaEspecie, String unaDescripcion, int ataqueBase, int saludBase, int unaVelocidad, int unNumeroEspecie, int unNiveldeEvolucion, 
		Especie especieAlaQueEvoluciona, Collection<Tipo> unosTipos) {
		super(unaEspecie, unaDescripcion, ataqueBase, saludBase, unaVelocidad, unNumeroEspecie, unosTipos)
		nivelEvolutivo = unNiveldeEvolucion
		evolucion = especieAlaQueEvoluciona
	}

	override def Especie evolucionaA(Pokemon unPokemon, Entrenador unEntrenador) {
		if (unPokemon.nivel >= nivelEvolutivo) { // Revisa si el nivel es suficiente, si lo es retorna la especie a la cual evoluciona si no, retorna la misma especie para que no haya cambios
			unEntrenador.sumarExperienciaDependiendoPerfilEvolucion(unPokemon)
			unEntrenador.sumarEvolucion
			unEntrenador.aniadirEspecie(evolucion)
			return evolucion
		} else
			return this
	}

}

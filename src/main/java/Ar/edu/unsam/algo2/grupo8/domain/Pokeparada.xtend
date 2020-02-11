package Ar.edu.unsam.algo2.grupo8.domain

import java.util.ArrayList
import java.util.Collection
import java.util.HashSet
import java.util.Set
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.geodds.Point

@Accessors
class Pokeparada {

	Collection<Entrenador> entrenadores = new ArrayList<Entrenador>
	Set<Item> inventario = new HashSet<Item>
	Point ubicacion
	String nombre
	int id

	new(String unNombre, Point _ubicacion, Collection<Item> items) {
		nombre = unNombre
		ubicacion = _ubicacion
		llenarInventario(items)
	}

	def llenarInventario(Collection<Item> items) {
		if(!items.nullOrEmpty){
			items.forEach[item|inventario.add(item)]
		}
	}

	def peticionDeAcceso(Entrenador unEntrenador) {
		if (!accesoAEntrenador(unEntrenador)) {
			throw new BusinessException("Se Encuentra demasiado lejos")
		}	
		entrenadores.add(unEntrenador)
		
	}

	def abandonarPokeparada(Entrenador unEntrenador) {
		if (!tieneAcceso(unEntrenador)) {
			throw new BusinessException("No puede abandonarla porque no se encuentra en la pokeparada")
		}	
		remocionEntrenador(unEntrenador)		
	}

	def remocionEntrenador(Entrenador unEntrenador) {
		entrenadores.remove(unEntrenador)
	}

	def accesoAEntrenador(Entrenador unEntrenador) {
		if (tieneAcceso(unEntrenador)) {
			throw new BusinessException("Ya tienen acceso a la pokeparada")
		}
		calcularDistancia(unEntrenador) < 10			
	}

	dispatch def calcularDistancia(Entrenador unEntrenador) {
		ubicacion.distance(unEntrenador.ubicacion)
	}

	dispatch def calcularDistancia(Point unaUbicacion){
		ubicacion.distance(unaUbicacion)
	}

	def tieneAcceso(Entrenador unEntrenador) {
		entrenadores.contains(unEntrenador)
	}

	def void curarPokemonesDe(Entrenador unEntrenador) {
		if(!tieneAcceso(unEntrenador)){
			throw new BusinessException("No se encuentra en la pokeparada")
		}
		unEntrenador.equipo.forEach[pokemon|pokemon.restaurarSalud]
	}

	def cambioDePokemonEquipoADeposito(Entrenador unEntrenador, Pokemon unPokemon) {
		if (!tieneAcceso(unEntrenador) || !unEntrenador.esParteDelEquipo(unPokemon) ||
			!unEntrenador.equipoTieneMasDeUnPokemon) {
			throw new BusinessException("Error al guardar Pokemon")
		}		
		unEntrenador.ponerPokemonDelEquipoEnElDeposito(unPokemon)
		//unEntrenador.equipo.remove(unPokemon)
		//unEntrenador.depositoPokemones.add(unPokemon)
		
	}

	def cambioDePokemonDespositoAEquipo(Entrenador unEntrenador, Pokemon unPokemon) {
		if (!tieneAcceso(unEntrenador) || !unEntrenador.espacioLibreEnEquipo ||
			!unEntrenador.estaEnElDeposito(unPokemon)) {
			throw new BusinessException("No se pudo retirar al pokemon ")
		}	
		unEntrenador.ponerPokemonDelDepositoEnElEquipo(unPokemon)
		//unEntrenador.equipo.add(unPokemon)
		//unEntrenador.depositoPokemones.remove(unPokemon)
					
	}

	def comprarItem(Item unItem, int unaCantidad, Entrenador unEntrenador) {
		if (!tieneAcceso(unEntrenador)){
			throw new BusinessException("No se encuentra en la pokeparada")
		}
		if (!estaDisponible(unItem)) {
			throw new BusinessException("Item no disponible")
		}	
		if (unEntrenador.dinero <= unItem.valor * unaCantidad) {
			throw new BusinessException("Dinero Insuficiente")
		}
		unEntrenador.adquirirItem(unItem, unaCantidad)
		
	}

	def estaDisponible(Item unItem) {
		inventario.contains(unItem)
	}

	def esValida() {
		!nombre.empty && ubicacion !== null
	}
}

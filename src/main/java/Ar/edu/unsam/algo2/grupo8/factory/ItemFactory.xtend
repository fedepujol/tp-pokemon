package Ar.edu.unsam.algo2.grupo8.factory

import Ar.edu.unsam.algo2.grupo8.domain.BusinessException
import Ar.edu.unsam.algo2.grupo8.domain.HiperPocion
import Ar.edu.unsam.algo2.grupo8.domain.IngredientePorcentaje
import Ar.edu.unsam.algo2.grupo8.domain.IngredientePorcentajePorTipo
import Ar.edu.unsam.algo2.grupo8.domain.IngredientePuntosFijos
import Ar.edu.unsam.algo2.grupo8.domain.Item
import Ar.edu.unsam.algo2.grupo8.domain.Pocion
import Ar.edu.unsam.algo2.grupo8.domain.Pokeball
import java.util.Collection
import java.util.HashMap
import java.util.Iterator
import java.util.Map

class ItemFactory {
	static var ItemFactory instance
	Map<Collection<String>, (String)=>Item> items

	private new() {
		this.initialize
	}
	
	static def getInstance() {
		if (instance.identityEquals(null)) {
			instance = new ItemFactory()
		}
		instance
	}

	def void initialize() {
		items = new HashMap<Collection<String>, (String)=>Item> => [
			put(#["pokeball", "superball", "ultraball"], [unString|new Pokeball(unString, 0, 0)])
			put(#["pocion", "superpocion"], [unString|new Pocion(unString, 0, 0)])
			put(#["hiperpocion"], [unString|new HiperPocion(unString)])
			put(#["hierro", "calcio"], [unString|new IngredientePuntosFijos(unString, 0.0, 0)])
			put(#["zinc", "proteina"], [unString|new IngredientePorcentaje(unString, 0.0, 0.0)])
			put(#["fertilizante", "purificador", "combustible", "cobre"], [ unString |
				new IngredientePorcentajePorTipo(unString, 0.0, 0.0, null, 0.0)
			])
		]
	}

	def getItem(String unString) {
		val item = busqueda(unString)
		if (item.identityEquals(null)) {
			throw new BusinessException("Error en Item: El Item es nulo")
		}
		item
	}

	def busqueda(String unString) {
		var Iterator<Map.Entry<Collection<String>, (String)=>Item>> entradas = items.entrySet.iterator
		var Map.Entry<Collection<String>, (String)=>Item> entrada
		var Item valor
		
		while (entradas.hasNext()) {
			entrada = entradas.next()
			if (entrada.key.contains(unString)) {
				valor = entrada.value.apply(unString)
			}
		}
		valor
	}
}

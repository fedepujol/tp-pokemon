package Ar.edu.unsam.algo2.grupo8.domain

import java.util.HashMap
import java.util.Iterator
import java.util.Map
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class TablaNiveles {
	Map<Integer, Integer> tabla = new HashMap<Integer, Integer>

	def agregarNivel(int unNivel, int unaExperiencia) {
		tabla.put(unNivel, unaExperiencia)
	}

	def nivelActual(int unaExperiencia) {
		var Iterator<Map.Entry<Integer, Integer>> entradas = tabla.entrySet.iterator
		var Map.Entry<Integer, Integer> entrada
		var Integer llave = 1
		var Integer valor = 0

		while (entradas.hasNext()) {
			entrada = entradas.next()
			valor = entrada.value
			if (unaExperiencia >= valor) {
				llave = entrada.key
			}
		}
		llave
	}
}

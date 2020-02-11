package Ar.edu.unsam.algo2.grupo8.domain

import java.util.Collection
import java.util.ArrayList
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Tipo {
	
	int idRepo
	String nombre // Nombre del tipo
	Collection<Tipo> tiposFuertes = new ArrayList<Tipo> // Tipos a los que este tipo es fuerte
	Collection<Tipo> tiposResistentes = new ArrayList<Tipo> // Tipos a los que este tipo es resistente
	
	new (String unNombre, Collection<Tipo> fuertes, Collection<Tipo> resistentes){ // Como crear el primer tipo?
		nombre = unNombre
		tiposFuertes = fuertes
		tiposResistentes = resistentes
	}
	
	def esValido(){
		nombre.length != 0
	}
}

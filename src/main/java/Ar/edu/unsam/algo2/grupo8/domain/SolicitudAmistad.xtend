package Ar.edu.unsam.algo2.grupo8.domain

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class SolicitudAmistad {
	var Entrenador emisor
	var Entrenador receptor
	
	new (Entrenador unEmisor, Entrenador unReceptor){
		emisor = unEmisor
		receptor = unReceptor
	}
	
}

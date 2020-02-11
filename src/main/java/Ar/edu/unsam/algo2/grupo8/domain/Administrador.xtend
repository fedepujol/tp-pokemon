package Ar.edu.unsam.algo2.grupo8.domain

import java.util.ArrayList
import java.util.Collection
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.commons.model.annotations.Observable

@Accessors
@Observable
class Administrador {
	Collection<Proceso> procesos = new ArrayList<Proceso>
	static var Administrador instance

	private new() {
	}

	static def getInstance() {
		if (instance.identityEquals(null)) {
			instance = new Administrador
		}
		instance
	}

	def agregarProceso(Proceso unProceso){
		if(procesos.contains(unProceso)){
			new BusinessException ("El proceso ya se encuentra en la lista")
		}
		procesos.add(unProceso)
	}
	
	def eliminarProceso(Proceso unProceso){
		if(!procesos.contains(unProceso)){
			new BusinessException ("El proceso no se encuentra en la lista")
		}
		procesos.remove(unProceso)
	}
	
	def ejecutarTodosLosProcesos(){
		procesos.forEach[proceso | proceso.doExecute]
	}
	
	def ejecutarProceso(Proceso unProceso) {
		unProceso.doExecute()
	}

}

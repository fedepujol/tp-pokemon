package Ar.edu.unsam.algo2.grupo8.repos

import Ar.edu.unsam.algo2.grupo8.domain.BusinessException
import Ar.edu.unsam.algo2.grupo8.domain.ServicioJSON
import Ar.edu.unsam.algo2.grupo8.domain.Tipo
import java.util.ArrayList
import java.util.Collection
import net.sf.json.JSONObject
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class RepositorioTipo extends RepoGenerico<Tipo> {

	int identificador = 1
	ServicioJSON servicioJSON
	Collection<Tipo> tipos = new ArrayList<Tipo>
	static var RepositorioTipo instance
	String descripcion

	private new() {
		descripcion = "Repositorio de Tipos"
		var Collection<Tipo> tiposAux = new ArrayList<Tipo>

		var acero = (new Tipo("Acero", new ArrayList<Tipo>, new ArrayList<Tipo>))
		var agua = (new Tipo("Agua", new ArrayList<Tipo>, new ArrayList<Tipo>))
		var bicho = (new Tipo("Bicho", new ArrayList<Tipo>, new ArrayList<Tipo>))
		var dragon = (new Tipo("Dragon", new ArrayList<Tipo>, new ArrayList<Tipo>))
		var electrico = (new Tipo("Electrico", new ArrayList<Tipo>, new ArrayList<Tipo>))
		var fantasma = (new Tipo("Fantasma", new ArrayList<Tipo>, new ArrayList<Tipo>))
		var fuego = (new Tipo("Fuego", new ArrayList<Tipo>, new ArrayList<Tipo>))
		var hada = (new Tipo("Hada", new ArrayList<Tipo>, new ArrayList<Tipo>))
		var hielo = (new Tipo("Hielo", new ArrayList<Tipo>, new ArrayList<Tipo>))
		var lucha = (new Tipo("Lucha", new ArrayList<Tipo>, new ArrayList<Tipo>))
		var normal = (new Tipo("Normal", new ArrayList<Tipo>, new ArrayList<Tipo>))
		var planta = (new Tipo("Planta", new ArrayList<Tipo>, new ArrayList<Tipo>))
		var psiquico = (new Tipo("Psiquico", new ArrayList<Tipo>, new ArrayList<Tipo>))
		var roca = (new Tipo("Roca", new ArrayList<Tipo>, new ArrayList<Tipo>))
		var siniestro = (new Tipo("Siniestro", new ArrayList<Tipo>, new ArrayList<Tipo>))
		var tierra = (new Tipo("Tierra", new ArrayList<Tipo>, new ArrayList<Tipo>))
		var veneno = (new Tipo("Veneno", new ArrayList<Tipo>, new ArrayList<Tipo>))
		var volador = (new Tipo("Volador", new ArrayList<Tipo>, new ArrayList<Tipo>))
		
		acero.tiposFuertes.addAll(hada, hielo, roca)
		acero.tiposResistentes.addAll(fuego, lucha, tierra)
		agua.tiposFuertes.addAll(fuego, roca, tierra)
		agua.tiposResistentes.addAll(electrico, planta)
		bicho.tiposFuertes.addAll(planta, psiquico, siniestro)
		bicho.tiposResistentes.addAll(fuego, roca, volador)
		dragon.tiposFuertes.addAll(dragon)
		dragon.tiposResistentes.addAll(dragon, hada, hielo)
		electrico.tiposFuertes.addAll(agua, volador)
		electrico.tiposResistentes.addAll(tierra)
		fantasma.tiposFuertes.addAll(fantasma, psiquico)
		fantasma.tiposResistentes.addAll(fantasma, siniestro)
		fuego.tiposFuertes.addAll(acero, bicho, hielo, planta)
		fuego.tiposResistentes.addAll(agua, roca, tierra)
		hada.tiposFuertes.addAll(dragon, lucha, roca)
		hada.tiposResistentes.addAll(acero, veneno)				
		hielo.tiposFuertes.addAll(dragon, planta, tierra, volador)
		hielo.tiposResistentes.addAll(acero, fuego, lucha, roca)
		lucha.tiposFuertes.addAll(acero, hielo, normal, roca, siniestro)
		lucha.tiposResistentes.addAll(hada, psiquico, volador)
		normal.tiposFuertes.addAll(normal)
		normal.tiposResistentes.addAll(lucha)
		planta.tiposFuertes.addAll(agua, psiquico, tierra)
		planta.tiposResistentes.addAll(bicho, fuego, hielo, veneno, volador)
		psiquico.tiposFuertes.addAll(lucha, veneno)
		psiquico.tiposResistentes.addAll(bicho, fantasma, siniestro)
		roca.tiposFuertes.addAll(bicho, fuego, hielo, volador)
		roca.tiposResistentes.addAll(acero, agua, lucha, planta, tierra)
		siniestro.tiposFuertes.addAll(fantasma, psiquico)
		siniestro.tiposResistentes.addAll(bicho, hada, lucha)
		tierra.tiposFuertes.addAll(acero, electrico, fuego, roca, veneno)
		tierra.tiposResistentes.addAll(agua, hielo, planta)
		veneno.tiposFuertes.addAll(hada, planta)
		veneno.tiposResistentes.addAll(psiquico, tierra)
		volador.tiposFuertes.addAll(bicho, lucha, planta)
		volador.tiposResistentes.addAll(electrico, hielo, roca)				
		
		
		tiposAux.addAll(acero, agua, bicho, dragon, electrico, fantasma, fuego, hada, hielo, lucha, normal, planta,
			psiquico, roca, siniestro, tierra, veneno, volador)
		tiposAux.forEach[tipo|this.create(tipo)]
	}

	static def getInstance() {
		if (instance.identityEquals(null)) {
			instance = new RepositorioTipo
		}
		instance
	}

	override create(Tipo unTipo) {
		if (!unTipo.esValido) {
			throw new BusinessException("Tipo invalido")
		}
		unTipo.idRepo = identificador
		tipos.add(unTipo)
		identificador++
	}

	override delete(Tipo unTipo) {
		if (!tipos.contains(unTipo)) {
			throw new BusinessException("El Tipo no existe en el repo")
		}
		tipos.remove(unTipo)
	}

	override update(Tipo unObjeto) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

	override searchById(int id) {
		tipos.findFirst[unTipo|unTipo.idRepo === id]
	}

	override search(String unValor) {
		tipos.filter[t| t.nombre.toLowerCase.contains(unValor.toLowerCase) || 
			t.nombre.toLowerCase == unValor.toLowerCase
		].toList
	}

	override crearObjeto(JSONObject unJsonObjeto) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

	override existeEnElRepo(Tipo unObjeto) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

	override updateAll() {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
	def searchByNombre(Collection<String> unosNombreTipos){
		val Collection<Tipo> tiposAux = new ArrayList<Tipo>
		unosNombreTipos.forEach[nombre|compararTipos(nombre, tiposAux)]
		tiposAux
	}
	
	def compararTipos(String unNombre, Collection<Tipo> tiposAux){
		tiposAux.addAll(tipos.filter[tipo | tipo.nombre.toLowerCase.equals(unNombre)])
	}

}

package Ar.edu.unsam.algo2.grupo8.domain

import Ar.edu.unsam.algo2.grupo8.sender.Mail
import Ar.edu.unsam.algo2.grupo8.sender.MessageSender
import java.util.ArrayList
import java.util.Collection
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.commons.model.annotations.Observable


@Accessors
@Observable
abstract class Accion {
	String emisor = "pokemonalgo@gmail.com"
	String descripcion

	def void notificar(Entrenador unEntrenador, int nivelAnterior)
}


@Accessors
@Observable
class NotificadorNivelMultiploDe5 extends Accion {
	
	String descripcion

	new (String unaDescripcion){
		descripcion = unaDescripcion
	}

	String notificacion = " ha subido a un nivel multiplo de 5"

	override notificar(Entrenador unEntrenador, int nivelAnterior) {
		notificacion = unEntrenador.nombre + notificacion
		if (unEntrenador.nivelActual() % 5 == 0) {
			unEntrenador.recibirNotificacion(notificacion)
			unEntrenador.listaAmigos.forEach[recibirNotificacion(notificacion)]
		}
	}
}
@Accessors
@Observable
class NotificadorSuperaAmigos extends Accion {
	
	String descripcion
	
	MessageSender messageSender
	String mensaje = "Fuiste superado por "

	val mail = new Mail => [
		//from = emisor
		titulo = "Notificacion"
	]

	new(MessageSender pMessageSender, String unaDescripcion) {
		descripcion = unaDescripcion
		messageSender = pMessageSender
	}

	override notificar(Entrenador unEntrenador, int nivelAnterior) {
		mail.message = mensaje + unEntrenador.nombre
		amigosNuevosSuperados(unEntrenador, nivelAnterior).forEach [ amigo |
			mail.to = amigo.mail
			amigo.recibirNotificacion(mail.message)
			messageSender.send(mail)
		]
	}

	def amigosNuevosSuperados(Entrenador unEntrenador, int nivelAnterior) {
		unEntrenador.listaAmigos.filter [ amigo |
			unEntrenador.nivelActual() > amigo.nivelActual() && nivelAnterior <= amigo.nivelActual()
		].toList
	}
}

@Accessors
@Observable
class NotificadorNivelMasAlto extends Accion {

	String descripcion
	
	MessageSender messageSender

	val Mail mail = new Mail => [
		//from = emisor
		titulo = "Notificacion"
	]

	new(MessageSender pMessageSender,  String unaDescripcion) {
		descripcion = unaDescripcion
		messageSender = pMessageSender
	}

	override notificar(Entrenador unEntrenador, int nivelAnterior) {
		mail.message = unEntrenador.nombre + " alcanzo el nivel mas alto"

		if (alcanzoElNivelMasAlto(unEntrenador)) {
			unEntrenador.listaAmigos.forEach [ amigo |
				mail.to = amigo.mail
				amigo.recibirNotificacion(mail.message)
				messageSender.send(mail)
			]
			mail.to = unEntrenador.mail
			unEntrenador.recibirNotificacion(mail.message)
			messageSender.send(mail)
		}
	}

	def alcanzoElNivelMasAlto(Entrenador unEntrenador) {
		unEntrenador.nivelActual() == unEntrenador.getNivel().tabla.keySet.last
	}
}


@Accessors
@Observable
class Recompensa extends Accion {
	String descripcion
	int nivelRecompensa
	int dineroRecompensa
	Collection<Item> itemsRecompensa = new ArrayList<Item>

	new(int unNivel, int unDinero, Collection<Item> unosItems,  String unaDescripcion) {
		descripcion = unaDescripcion
		nivelRecompensa = unNivel
		dineroRecompensa = unDinero
		itemsRecompensa = unosItems
	}

	override notificar(Entrenador unEntrenador, int nivelAnterior) {
		if (unEntrenador.nivelActual() == nivelRecompensa) {
			unEntrenador.sumarDinero(dineroRecompensa)
			itemsRecompensa.forEach[item|unEntrenador.adquirirItemRecompensa(item)]
		}
	}
}


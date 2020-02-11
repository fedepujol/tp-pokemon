package Ar.edu.unsam.algo2.grupo8.sender

import java.util.HashMap
import java.util.HashSet
import java.util.Map
import java.util.Set

class StubMailSender implements MessageSender {
	Map<String, Set<String>> mailsEnviados

	new() {
		mailsEnviados = new HashMap<String, Set<String>>
	}

	override send(Mail mail) {
		simularEnvioMail(mail.from, mail.message)
	}

	def simularEnvioMail(String from, String message) {
		val mensajes = mailsDe(from)
		mensajes.add(message)
		mailsEnviados.put(from, mensajes)
	}

	def Set<String> mailsDe(String from) {
		mailsEnviados.get(from) ?: new HashSet<String>
	}
}

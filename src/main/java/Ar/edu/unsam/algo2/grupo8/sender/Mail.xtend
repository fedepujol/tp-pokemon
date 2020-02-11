package Ar.edu.unsam.algo2.grupo8.sender

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Mail {
	
	String from
	String to
	String message
	String titulo

	override equals(Object o) {
		try {
			val Mail otro = o as Mail
			return otro.message.equals(message)
		} catch (ClassCastException e) {
			return false
		}
	}

	override hashCode() {
		message.hashCode
	}
}

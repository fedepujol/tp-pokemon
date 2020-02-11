package Ar.edu.unsam.algo2.grupo8.domain

import java.util.concurrent.ThreadLocalRandom

class Randomize {
	public static var random = [|return Math.random]

	def aplicarRandom() {
		random.apply
	}

	def aplicarRandomValores(int valorInicial, int valorFinal) {
		ThreadLocalRandom.current().nextInt(valorInicial, valorFinal)
	}

	def aplicarRandomValores(double valorInicial, double valorFinal) {
		ThreadLocalRandom.current().nextDouble(valorInicial, valorFinal)
	}
}

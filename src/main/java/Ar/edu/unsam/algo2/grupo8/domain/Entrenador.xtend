package Ar.edu.unsam.algo2.grupo8.domain

import com.fasterxml.jackson.annotation.JsonIgnore
import com.fasterxml.jackson.annotation.JsonProperty
import java.util.ArrayList
import java.util.Collection
import java.util.HashMap
import java.util.HashSet
import java.util.Iterator
import java.util.Map
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.geodds.Point

@Accessors
class Entrenador {

	String nombre
	@JsonIgnore String mail
	@JsonIgnore PerfilEntrenador perfil
	Point ubicacion
	int id
	int idPokemon = 1
	int idItem = 1
	int experiencia = 0
	int batallasGanadas = 0
	@JsonIgnore int pokemonesEvolucionados = 0
	double dinero
	double apuesta
	@JsonIgnore TablaNiveles nivel = new TablaNiveles
	@JsonIgnore Randomize random = new Randomize
	Collection<Especie> especiesAtrapadas = new HashSet<Especie>
	Collection<Pokemon> equipo = new ArrayList<Pokemon>
	Collection<Pokemon> depositoPokemones = new ArrayList<Pokemon>
	@JsonIgnore Collection<SolicitudAmistad> solicitudesPendientes = new ArrayList<SolicitudAmistad>
	@JsonIgnore Collection<Entrenador> listaAmigos = new ArrayList<Entrenador>
	@JsonIgnore Collection<String> notificaciones = new ArrayList<String>
	@JsonIgnore Collection<Accion> acciones = new ArrayList<Accion>
	Map<Item, Integer> inventario = new HashMap<Item, Integer>

	new(String _nombre, PerfilEntrenador _perfil, Point _ubicacion, double unDinero) {
		nombre = _nombre
		perfil = _perfil
		ubicacion = _ubicacion
		dinero = unDinero
		mail = nombre.toLowerCase + "@gmail.com"
		apuesta = dinero * 0.25
	}

	def pokemonesAtrapados() {
		equipo + depositoPokemones
	}

	def nivelActual() {
		nivel.nivelActual(experiencia)
	}

	def void sumarEvolucion() {
		pokemonesEvolucionados += 1
	}

	def esExperto() {
		perfil.esExperto(this)
	}

	def cantidadDeEspeciesDistintasAtrapadas() {
		especiesAtrapadas.size
	}

	def coleccionBalanceada() {
		return ((machosSobreElTotal <= 0.55) && (machosSobreElTotal >= 0.45))
	}

	def pokemonesMacho() {
		pokemonesAtrapados.filter[pokemon|pokemon.genero == ("Macho")]
	}

	def machosSobreElTotal() {

		if (cantidadPokemonesAtrapados() <= 0) {
			throw new BusinessException("No tienes pokemones atrapados")
		}

		pokemonesMacho.size().doubleValue / cantidadPokemonesAtrapados().doubleValue

	}

	def cantidadPokemonesAtrapados() {
		pokemonesAtrapados.size()
	}

	def cantidadPokemonesConNivelMayorA(int unNivel) {
		pokemonesAtrapados.filter(pokemon|pokemon.nivel > unNivel).size()
	}

	def moverseA(Point unaUbicacion, Pokeparada unaPokeparada) {
		ubicacion = unaUbicacion
		if (estaEnLaPokeparada(unaPokeparada)) {
			if (unaPokeparada.calcularDistancia(this) > 10) {
				unaPokeparada.remocionEntrenador(this)
			}
		}
	}

	def intentarAtraparA(Pokemon unPokemon, Pokeball unaPokebola) {
		if (unPokemon.distanciaRespectoAUnPunto(ubicacion).intValue >= 10) {
			throw new BusinessException("La Distancia supera el maximo permitido")
		}
		this.atraparA(unPokemon, unaPokebola)
	}

	def atraparA(Pokemon unPokemon, Pokeball unaPokebola) {
		val double entrenadorChances = this.chancesDeAtrapar(unaPokebola)
		if ((random.aplicarRandom) <= (entrenadorChances / (entrenadorChances + unPokemon.chancesEscapar))) {
			sumarExperienciaDependiendoDePerfilCaptura(unPokemon, 100)
			agregarPokemon(unPokemon)
		}
	}

	def chancesDeAtrapar(Pokeball unaPokebola) {
		var double chance = 0

		if (perfil.esExperto(this)) {
			chance = nivelActual() * 1.5
		} else
			chance = nivelActual()

		chance * chancesPokeball(unaPokebola)
	}

	def chancesPokeball(Pokeball unaPokebola) {
		if (inventario.get(unaPokebola) <= 0) {
			throw new RuntimeException("Usted no tiene mas " + unaPokebola.nombre + "s!")
		} else {
			unaPokebola.utilizar
			inventario.put(unaPokebola, inventario.get(unaPokebola) - 1)
		}
	}

	def agregarPokemon(Pokemon unPokemon) {
		unPokemon.idPokemon = idPokemon
		idPokemon++
		aniadirEspecie(unPokemon.especie)
		if (espacioLibreEnEquipo) {
			equipo.add(unPokemon)
		} else
			depositoPokemones.add(unPokemon)
	}

	def espacioLibreEnEquipo() {
		equipo.size < 6
	}

	def sumarExperienciaDependiendoDePerfilCaptura(Pokemon unPokemon, int unaExperiencia) {
		if (especieNueva(unPokemon)) {
			sumarExperiencia(perfil.experienciaPorCapturaNuevaEspecie)
		}
	}

	def especieNueva(Pokemon unPokemon) {
		!especiesAtrapadas.toList.contains(unPokemon.especie)
	}

	def sumarExperiencia(int unaExperiencia) {
		val nivelAnterior = nivelActual()
		experiencia += unaExperiencia
		if (nivelActual() > nivelAnterior) {
			acciones.forEach[accion|accion.notificar(this, nivelAnterior)]
		}
	}

	def distanciaRespectoAUnPunto(Point punto) {
		ubicacion.distance(punto)
	}

	def enfrentateSiPodes(Entrenador unNpc, Pokemon unPokemon, double unaApuesta, Integer unId) {
		if (puedeEnfrentarseA(unNpc)) {
			enfrentarseA(unNpc, unPokemon, unaApuesta, unId)
		}
	}

	def puedeEnfrentarseA(Entrenador unNpc) {
		unNpc.distanciaRespectoAUnPunto(ubicacion) < 5
	}

	def void enfrentarseA(Entrenador unNpc, Pokemon pokemonRival, double unaApuesta, Integer unId) {
		val pokemonElegido = buscarPokemonId(unId)
		if (ganoBatalla(pokemonElegido, pokemonRival, unNpc, unaApuesta)) {
			consecuenciasGanador(pokemonRival, unaApuesta, unNpc, pokemonElegido)
		} else
			consecuenciasPerdedor(unaApuesta, pokemonElegido)
	}

	def ganoBatalla(Pokemon pokemonElegido, Pokemon pokemonRival, Entrenador unNpc, double unaApuesta) {
		random.aplicarRandom <= (pokemonElegido.chancesDeGanarBatalla(this, pokemonRival) /
			(pokemonElegido.chancesDeGanarBatalla(this, pokemonRival) +
				pokemonRival.chancesDeGanarBatalla(unNpc, pokemonElegido)))
		}

		def elegirPokemonParaLuchar() { // Depende si se elige cualquier pokemon (lo haya atrapado o no) o exclusivamente del equipo
			equipo.get(random.aplicarRandomValores(0, equipo.size))
		}

		def sumarDinero(double unDinero) {
			dinero += unDinero
		}

		def sumarExperienciaDependiendoDePerfilBatalla(Entrenador unNpc) {
			if (unNpc.nivelActual() > nivelActual()) {
				sumarExperiencia(perfil.experienciaPorBatallaGanada)
			}
		}

		def consecuenciasGanador(Pokemon pokemonRival, double unaApuesta, Entrenador unNpc, Pokemon pokemonElegido) {
			sumarDinero(unaApuesta)
			sumarExperienciaDependiendoDePerfilBatalla(unNpc)
			batallasGanadas += 1
			pokemonElegido.sumarExperiencia(pokemonRival, this)
			pokemonElegido.recibirDanio(pokemonRival)
		}

		def consecuenciasPerdedor(double unaApuesta, Pokemon unPokemon) {
			sumarDinero(unaApuesta * -1d)
			unPokemon.quedarKO
		}

		def sumarExperienciaDependiendoPerfilEvolucion(Pokemon unPokemon) {
			sumarExperiencia((perfil.experienciaPorEvolucion(unPokemon.experiencia)).intValue)
		}

		def accederAPokeparada(Pokeparada unaPokeparada) {
			unaPokeparada.peticionDeAcceso(this)
		}

		def abandonarPokeparada(Pokeparada unaPokeparada) {
			unaPokeparada.abandonarPokeparada(this)
		}

		def curarEquipo(Pokeparada unaPokeparada) {
			unaPokeparada.curarPokemonesDe(this)
		}

		def boolean estaEnLaPokeparada(Pokeparada unaPokeparada) {
			unaPokeparada.tieneAcceso(this)
		}

		def comprarItem(Pokeparada unaPokeparada, Item unItem, int unaCantidad) {
			unaPokeparada.comprarItem(unItem, unaCantidad, this)
		}

		def adquirirItem(Item unItem, int unaCantidad) {
			dinero -= unItem.valor * unaCantidad
			if (existeEnInventario(unItem)) {
				inventario.replace(unItem, inventario.get(unItem), inventario.get(unItem) + unaCantidad)
			}
			unItem.id = idItem
			idItem++
			inventario.put(unItem, unaCantidad)
		}

		def adquirirItemRecompensa(Item unItem) {
			if (existeEnInventario(unItem)) {
				inventario.replace(unItem, inventario.get(unItem), inventario.get(unItem) + 1)
			} else {
				inventario.put(unItem, 1)
			}
		}

		def existeEnInventario(Item unItem) {
			inventario.keySet.contains(unItem)
		}

		def ponerPokemonDelEquipoEnElDeposito(Pokemon unPokemon) {
			depositoPokemones.add(unPokemon)
			equipo.remove(unPokemon)
		}

		def ponerPokemonDelDepositoEnElEquipo(Pokemon unPokemon) {
			equipo.add(unPokemon)
			depositoPokemones.remove(unPokemon)
		}

		def boolean esParteDelEquipo(Pokemon unPokemon) {
			equipo.contains(unPokemon)
		}

		def boolean estaEnElDeposito(Pokemon unPokemon) {
			depositoPokemones.contains(unPokemon)
		}

		def boolean equipoTieneMasDeUnPokemon() {
			equipo.size > 1
		}

		def aniadirEspecie(Especie unaEspecie) {
			especiesAtrapadas.add(unaEspecie)
		}

		def curarPokemon(Pokemon unPokemon, Quimico unQuimico) {
			if (!pokemonesAtrapados.toList.contains(unPokemon)) {
				throw new BusinessException("No posee el pokemon a curar")
			}
			if (esUnaPocion(unQuimico)) {
				validarQueTengaItem(unQuimico)
				restarItem(unQuimico)
			}
			unQuimico.curarPokemon(unPokemon)
		}

		def esUnaPocion(Quimico unQuimico) {
			unQuimico.class.genericSuperclass ==
				new Pocion("a", 0, 0).class.genericSuperclass
		}

		def restarItem(Item unItem) {
			inventario.put(unItem, inventario.get(unItem) - 1)
		}

		def Ingrediente prepararPocionCustom(
			Quimico unQuimico,
			Ingrediente unIngrediente) {

				var Ingrediente ingrediente

				if (esUnaPocion(unQuimico)) {
					validarQueTengaItem(unQuimico)
					restarItem(unQuimico)
				}
				validarQueTengaItem(unIngrediente)
				restarItem(unIngrediente)
				ingrediente = unIngrediente.clone
				ingrediente.decorado = unQuimico
				ingrediente
			}

			def validarQueTengaItem(Item unItem) {
				if (!existeEnInventario(unItem)) {
					throw new BusinessException(unItem.nombre +
						" no esta en el inventario")
				}
				if (noQuedanMas(unItem)) {
					throw new BusinessException("No le quedan mas " + unItem.nombre)
				}
			}

			def noQuedanMas(Item unItem) {
				inventario.get(unItem).equals(0)
			}

			def enviarSolicitudA(Entrenador unReceptor) {
				var unaSolicitud = new SolicitudAmistad(this, unReceptor)

				if (listaAmigos.contains(unReceptor)) {
					throw new BusinessException("Ustedes ya son Amigos")
				}

				unReceptor.recibirSolicitud(unaSolicitud)
			}

			def recibirSolicitud(SolicitudAmistad unaSolicitud) {
				solicitudesPendientes.add(unaSolicitud)
			}

			def aceptarORechazar(SolicitudAmistad unaSolicitud) {
				random = new Randomize()
				if (!solicitudesPendientes.contains(unaSolicitud)) {
					throw new BusinessException("No es una solicitud pendiente")
				}
				if (random.aplicarRandom() == 1) {
					rechazarSolicitud(unaSolicitud)
				} else {
					aceptarSolicitud(unaSolicitud)
				}
			}

			def rechazarSolicitud(SolicitudAmistad unaSolicitud) {
				solicitudesPendientes.remove(unaSolicitud)
			}

			def aceptarSolicitud(SolicitudAmistad unaSolicitud) {
				agregarAmigo(unaSolicitud.emisor)
				unaSolicitud.emisor.agregarAmigo(this)
				solicitudesPendientes.remove(unaSolicitud)
			}

			def agregarAmigo(Entrenador unEntrenador) {
				listaAmigos.add(unEntrenador)
			}

			def eliminarAmigo(Entrenador unEntrenador) {
				if (!listaAmigos.contains(unEntrenador)) {
					throw new BusinessException(
						"No puede eliminar un usuario que no es su amigo")
				}
				borrarAmigo(unEntrenador)
				unEntrenador.borrarAmigo(this)
			}

			def borrarAmigo(Entrenador unEntrenador) {
				listaAmigos.remove(unEntrenador)
			}

			def void recibirNotificacion(String unaNotificacion) {
				notificaciones.add(unaNotificacion)
			}

			def esValido() {
				nombre != "" && mail != "" && ubicacion !== null && perfil !== null
			}

			def buscarPokemonId(Integer unId) {
				equipo.findFirst[pokemon|pokemon.idPokemon === unId]
			}

			def updateItem(Item unItem, Integer unInteger) {
				inventario.put(unItem, unInteger)
			}

			def estaEnEquipo(Pokemon unPokemon) {
				equipo.contains(unPokemon)
			}

			def itemId(Integer unId) {
				inventario.keySet.findFirst[item|item.id == unId]
			}

			def cantidadItemPorId(Integer unId) {
				var Iterator<Map.Entry<Item, Integer>> entradas = inventario.
					entrySet.iterator
				var Map.Entry<Item, Integer> entrada
				var Item llave
				var Integer valor = 0

				while (entradas.hasNext()) {
					entrada = entradas.next()
					llave = entrada.key
					if (unId === llave.id) {
						valor = entrada.value
					}
				}
				valor
			}

			@JsonProperty("perfil")
			def String getPerfilEntrenador() {
				if (perfil === null) {
					return ""
				}
				perfil.nombre
			}

			@JsonProperty("esExperto")
			def Boolean getExperto() {
				perfil.esExperto(this)
			}

		}
		
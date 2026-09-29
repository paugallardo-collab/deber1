# Respuestas del Deber 1

## 1 Comportamiento de setState al volver

En la prueba de la rama `version/setstate`, incremente el contador de 0 a 1 en Control y use el boton atras del sistema. El repositorio quedo con 1, pero el Visor siguio mostrando 0. El dato persistido era correcto; lo desactualizado era la copia local `_contador` que pertenece al `State` del Visor. Esa pantalla solo ejecuta `setState` cuando recibe un entero del `Navigator.pop`. El boton atras cierra la ruta con `null`, por eso no habia un resultado que aplicar.

En esta implementacion el viaje del contador exige que cinco puntos se pongan de acuerdo: el estado del Visor, los argumentos de la ruta, el constructor y estado local de Control, el valor devuelto por `Navigator.pop` y el resultado esperado por el Visor. El repositorio persiste el valor, pero no sincroniza por si solo esas dos copias de interfaz.

## 2 Por que Riverpod funciona con el boton atras

En `version/riverpod`, Control actualiza `contadorProvider` y el Visor observa ese mismo provider. Al volver con el boton del sistema no hace falta devolver un valor: la ruta desaparece, el Visor vuelve a mostrarse y ya tiene el ultimo estado emitido por `ContadorNotifier`.

El contador vive en el provider ubicado dentro del `ProviderScope`, por encima de las dos pantallas. Las pantallas no se pasan el contador ni los casos de uso por constructor.

## 3 Informacion que aporta BlocObserver

El `BlocObserver` muestra cada transicion con el valor anterior y el siguiente, por ejemplo `ContadorCubit: 3 -> 4`. Pude comprobar el orden completo de carga, incrementos y decrementos sin poner impresiones dentro de los botones.

Ese registro seria util si un carrito, un formulario por pasos o una sesion terminan en un estado inesperado. La secuencia permite identificar cual accion produjo el primer valor incorrecto y que valor existia justo antes.

## 4 Evidencia de la separacion de capas

Ejecute los comandos desde `parte_a_contador`.

| Comando | Salida observada |
|---|---|
| `git diff version/setstate version/riverpod -- lib/domain lib/data` | Sin salida |
| `git diff version/setstate version/bloc -- lib/domain lib/data` | Sin salida |
| `git diff version/setstate version/bloc --stat -- lib/presentation` | Tres archivos de presentation cambiaron |

Salida del tercer comando:

```text
 .../lib/presentation/estado/contador_cubit.dart    |  33 +++++++
 .../presentation/pantallas/pantalla_control.dart   |  90 ++++--------------
 .../lib/presentation/pantallas/pantalla_visor.dart | 104 +++++----------------
 3 files changed, 74 insertions(+), 153 deletions(-)
```

Los dos primeros comandos vacios demuestran que las tres versiones usan exactamente los mismos contratos, casos de uso y acceso a datos. El tercer comando demuestra que la variacion esta contenida en presentacion. Si cambiara Riverpod por otro paquete, reescribiria el administrador de estado, las pantallas que lo consumen y la composicion de dependencias en `main.dart`; no cambiaria las reglas ni el repositorio.

## 5 Comparacion de las tres versiones

| Observacion | setState | Riverpod | Cubit |
|---|---|---|---|
| Donde vive el contador | En el `State` del Visor y otra copia temporal en Control | En `ContadorNotifier`, dentro de `ProviderScope` | En el estado inmutable de `ContadorCubit` |
| Las pantallas se pasan datos | Si. Pasan valor y casos de uso, y esperan un resultado al volver | No | No |
| Archivos de presentation modificados | Dos pantallas | Provider y dos pantallas | Cubit y dos pantallas |
| Boton atras del sistema | El valor se guarda, pero el Visor queda viejo | El Visor muestra el valor compartido | El Visor muestra el ultimo estado emitido |
| Se modifico domain | No | No | No |

Para una app de una sola pantalla elegiria `setState`: el estado es pequeno, local y no necesita infraestructura adicional. Para ocho pantallas que comparten cinco datos elegiria Cubit porque centraliza cada estado y su `BlocObserver` permite seguir las transiciones; Riverpod tambien resolvio bien el estado compartido, pero Cubit hizo mas explicita la secuencia.

`setState` es la opcion correcta para estado visual local y de vida corta, como mostrar una seccion, seleccionar una pestana interna o controlar una animacion. Tambien conviene cuando ningun otro widget o ruta necesita ese dato.

## 6 Por que Future mostro un valor viejo

La pantalla de `Future` consulta una vez y conserva el resultado en su `State`. En la prueba mostro Wi-Fi; despues cambie el estado del repositorio a sin conexion y la pantalla siguio mostrando Wi-Fi hasta pulsar **Consultar ahora** otra vez. La app no tenia un dato falso cuando lo obtuvo: tenia un dato correcto de un momento anterior. La hora visible ayuda a reconocer esa antiguedad.

## 7 Consecuencia de no cancelar la suscripcion

Si se elimina `cancel()` y el usuario entra y sale cincuenta veces, quedan hasta cincuenta suscripciones activas. Cada cambio de red intenta llegar a Cubits que ya no deberian existir, repite trabajo y conserva objetos en memoria. Esto puede producir emisiones duplicadas, consumo creciente y errores por intentar emitir despues del cierre. La prueba de `ConexionCubit` verifica que `close()` cancela la suscripcion.

## 8 Future como foto y Stream como pelicula

El `Future` fue una foto porque respondio como estaba la conexion en el instante de la consulta y termino. Cuando el estado cambio, esa respuesta no recibio una correccion. El `Stream` fue una pelicula porque mantuvo una suscripcion abierta: al llegar un nuevo estado, el Cubit emitio otro valor y la pantalla cambio sin pulsar ningun boton.

En una app real usaria `Future` para cargar el detalle de un perfil y para pedir el historial de una orden al abrir su pantalla. Usaria `Stream` para mensajes nuevos de un chat y para la ubicacion en vivo de un repartidor.

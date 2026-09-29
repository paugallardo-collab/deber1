# Deber 1 Estado y Streams

Entrega de Programacion Asistida de Aplicaciones sobre manejo de estado, persistencia, `Future`, `Stream` y arquitectura limpia.

## Contenido

- `parte_a_contador`: contador persistente. El nucleo esta en `main` y las tres implementaciones estan en `version/setstate`, `version/riverpod` y `version/bloc`.
- `parte_b_conexion`: comparacion visual entre una consulta con `Future` y una observacion con `Stream` y Cubit.
- `RESPUESTAS.md`: ocho respuestas, comparacion entre administradores y evidencia de los `git diff`.
- `GUIA_DEMO.md`: pasos exactos para grabar el unico artefacto que requiere un telefono real.

## Ejecutar la Parte A

Desde la raiz de este repositorio:

```bash
git switch version/setstate
cd parte_a_contador
flutter pub get
flutter run
```

Cambie la rama por `version/riverpod` o `version/bloc` para ejecutar las otras versiones. Las tres ramas nacen del mismo commit de `domain` y `data`.

## Ejecutar la Parte B

```bash
git switch main
cd parte_b_conexion
flutter pub get
flutter run
```

La pestana **Con Future** requiere pulsar **Consultar ahora**. La pestana **Con Stream** cambia cuando `connectivity_plus` informa un nuevo estado.

## Verificaciones

Cada proyecto se valida con:

```bash
flutter analyze
flutter test
```

Pruebas incluidas:

- persistencia y casos de uso del contador;
- resultado obsoleto de `setState` al volver con el boton del sistema;
- estado compartido al volver con Riverpod y Cubit;
- secuencia de emisiones de `ContadorCubit`;
- diferencia observable entre la foto de `Future` y el flujo de `Stream`;
- cancelacion de la suscripcion de `ConexionCubit`.

## Arquitectura

La direccion de dependencias es `presentation -> domain <- data`. El dominio no importa Flutter ni paquetes externos. `shared_preferences` aparece solo en el repositorio de datos de la Parte A y `connectivity_plus` aparece solo en el repositorio de datos de la Parte B. Las clases concretas se componen en `main.dart`.

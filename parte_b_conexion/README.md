# Parte B Conexion

Esta app compara una consulta puntual con `Future` y una observacion continua con `Stream`. Las dos experiencias usan el mismo contrato de dominio y el mismo repositorio de `connectivity_plus`.

## Ejecutar

```bash
flutter pub get
flutter run
```

La pestana **Con Future** cambia solo al presionar **Consultar ahora**. La pestana **Con Stream** se actualiza cuando el sistema operativo informa un cambio de red.

## Verificar

```bash
flutter analyze
flutter test
```

`connectivity_plus` aparece en un solo archivo dentro de `lib`: `data/repositories/conexion_plus_repository.dart`. El `ConexionCubit` cancela su `StreamSubscription` en `close()`.

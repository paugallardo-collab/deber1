# Guia para grabar demo mp4

El video debe mostrar un cambio real informado por el sistema operativo. Por eso se graba en un telefono o emulador con controles de red, no se reemplaza por una animacion preparada.

## Preparacion

1. Conecte un telefono Android con depuracion USB o abra un emulador.
2. Desde `parte_b_conexion`, ejecute `flutter run`.
3. Abra la pestana **Con Stream** y espere a que muestre el estado inicial.
4. Inicie la grabacion de pantalla del dispositivo.

## Toma de 15 a 20 segundos

1. Muestre **Wi-Fi** en la pestana Con Stream.
2. Abra los ajustes rapidos y apague Wi-Fi. Si no hay datos moviles, la app debe mostrar **Sin conexion**; con datos debe mostrar **Datos moviles**.
3. Encienda Wi-Fi y espere a que la app vuelva sola a **Wi-Fi**.
4. Detenga la grabacion.
5. Nombre el archivo `demo.mp4` y copielo en la raiz de `Deber1`, junto a `RESPUESTAS.md`.

No pulse ningun boton dentro de la app durante los cambios. Esa es la evidencia de que el `Stream` recibe eventos nuevos.

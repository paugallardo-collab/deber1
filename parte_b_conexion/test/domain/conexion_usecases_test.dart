import 'package:flutter_test/flutter_test.dart';
import 'package:parte_b_conexion/domain/entities/estado_conexion.dart';
import 'package:parte_b_conexion/domain/usecases/consultar_conexion.dart';
import 'package:parte_b_conexion/domain/usecases/observar_conexion.dart';

import '../ayudas/repository_falso.dart';

void main() {
  test('ConsultarConexion devuelve el estado actual', () async {
    final repository = ConexionRepositoryFalso()
      ..actual = EstadoConexion.datosMoviles;

    expect(await ConsultarConexion(repository)(), EstadoConexion.datosMoviles);
    await repository.cerrar();
  });

  test('ObservarConexion entrega cada cambio futuro', () async {
    final repository = ConexionRepositoryFalso();
    final resultado = ObservarConexion(repository)().first;

    repository.controlador.add(EstadoConexion.sinConexion);

    expect(await resultado, EstadoConexion.sinConexion);
    await repository.cerrar();
  });
}

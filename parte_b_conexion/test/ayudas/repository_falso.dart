import 'dart:async';

import 'package:parte_b_conexion/domain/entities/estado_conexion.dart';
import 'package:parte_b_conexion/domain/repositories/conexion_repository.dart';

class ConexionRepositoryFalso implements ConexionRepository {
  EstadoConexion actual = EstadoConexion.wifi;
  bool suscripcionCancelada = false;

  late final StreamController<EstadoConexion> controlador =
      StreamController<EstadoConexion>.broadcast(
        onCancel: () => suscripcionCancelada = true,
      );

  @override
  Future<EstadoConexion> consultarAhora() async => actual;

  @override
  Stream<EstadoConexion> observarCambios() => controlador.stream;

  Future<void> cerrar() => controlador.close();
}

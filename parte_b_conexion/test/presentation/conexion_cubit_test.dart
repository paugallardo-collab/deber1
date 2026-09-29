import 'package:flutter_test/flutter_test.dart';
import 'package:parte_b_conexion/domain/entities/estado_conexion.dart';
import 'package:parte_b_conexion/domain/usecases/consultar_conexion.dart';
import 'package:parte_b_conexion/domain/usecases/observar_conexion.dart';
import 'package:parte_b_conexion/presentation/estado/conexion_cubit.dart';

import '../ayudas/repository_falso.dart';

void main() {
  test(
    'consulta, observa cambios y cancela la suscripcion al cerrar',
    () async {
      final repository = ConexionRepositoryFalso();
      final cubit = ConexionCubit(
        ConsultarConexion(repository),
        ObservarConexion(repository),
      );
      final estados = <EstadoConexion>[];
      final suscripcion = cubit.stream.listen(estados.add);

      await cubit.iniciar();
      repository.controlador.add(EstadoConexion.sinConexion);
      await Future<void>.delayed(Duration.zero);

      expect(estados, [EstadoConexion.wifi, EstadoConexion.sinConexion]);

      await cubit.close();
      await Future<void>.delayed(Duration.zero);
      expect(repository.suscripcionCancelada, isTrue);

      await suscripcion.cancel();
      await repository.cerrar();
    },
  );
}

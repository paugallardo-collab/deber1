import 'package:flutter_test/flutter_test.dart';
import 'package:parte_a_contador/domain/repositories/contador_repository.dart';
import 'package:parte_a_contador/domain/usecases/decrementar.dart';
import 'package:parte_a_contador/domain/usecases/incrementar.dart';
import 'package:parte_a_contador/domain/usecases/obtener_contador.dart';
import 'package:parte_a_contador/presentation/estado/contador_cubit.dart';

class RepositoryFalso implements ContadorRepository {
  int valor = 0;

  @override
  Future<void> guardar(int nuevoValor) async => valor = nuevoValor;

  @override
  Future<int> leer() async => valor;
}

void main() {
  test('emite la secuencia completa de cambios', () async {
    final repository = RepositoryFalso()..valor = 2;
    final cubit = ContadorCubit(
      ObtenerContador(repository),
      Incrementar(repository),
      Decrementar(repository),
    );
    final estados = <int>[];
    final suscripcion = cubit.stream.listen(estados.add);

    await cubit.cargar();
    await cubit.incrementar();
    await cubit.decrementar();
    await Future<void>.delayed(Duration.zero);

    expect(estados, [2, 3, 2]);
    await suscripcion.cancel();
    await cubit.close();
  });
}

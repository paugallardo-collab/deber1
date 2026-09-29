import 'package:flutter_test/flutter_test.dart';
import 'package:parte_a_contador/domain/repositories/contador_repository.dart';
import 'package:parte_a_contador/domain/usecases/decrementar.dart';
import 'package:parte_a_contador/domain/usecases/incrementar.dart';
import 'package:parte_a_contador/domain/usecases/obtener_contador.dart';

class ContadorRepositoryEnMemoria implements ContadorRepository {
  int valor = 0;

  @override
  Future<void> guardar(int nuevoValor) async {
    valor = nuevoValor;
  }

  @override
  Future<int> leer() async => valor;
}

void main() {
  late ContadorRepositoryEnMemoria repository;

  setUp(() {
    repository = ContadorRepositoryEnMemoria();
  });

  test('obtener devuelve el valor guardado', () async {
    repository.valor = 7;

    expect(await ObtenerContador(repository)(), 7);
  });

  test('incrementar suma uno y persiste el resultado', () async {
    repository.valor = 2;

    expect(await Incrementar(repository)(), 3);
    expect(repository.valor, 3);
  });

  test('decrementar resta uno y persiste el resultado', () async {
    repository.valor = 2;

    expect(await Decrementar(repository)(), 1);
    expect(repository.valor, 1);
  });
}

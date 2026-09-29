import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parte_a_contador/domain/repositories/contador_repository.dart';
import 'package:parte_a_contador/domain/usecases/decrementar.dart';
import 'package:parte_a_contador/domain/usecases/incrementar.dart';
import 'package:parte_a_contador/domain/usecases/obtener_contador.dart';
import 'package:parte_a_contador/main.dart';

class RepositoryFalso implements ContadorRepository {
  int valor = 0;

  @override
  Future<void> guardar(int nuevoValor) async => valor = nuevoValor;

  @override
  Future<int> leer() async => valor;
}

void main() {
  testWidgets('Atras del sistema conserva el estado emitido por Cubit', (
    tester,
  ) async {
    final repository = RepositoryFalso();
    await tester.pumpWidget(
      AplicacionContador(
        obtenerContador: ObtenerContador(repository),
        incrementar: Incrementar(repository),
        decrementar: Decrementar(repository),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('ir-control')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('incrementar')));
    await tester.pumpAndSettle();
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(repository.valor, 1);
    expect(find.text('Contador: 1'), findsOneWidget);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parte_a_contador/domain/repositories/contador_repository.dart';
import 'package:parte_a_contador/main.dart';
import 'package:parte_a_contador/presentation/estado/contador_provider.dart';

class RepositoryFalso implements ContadorRepository {
  int valor = 0;

  @override
  Future<void> guardar(int nuevoValor) async => valor = nuevoValor;

  @override
  Future<int> leer() async => valor;
}

void main() {
  testWidgets('Atras del sistema conserva el estado compartido', (
    tester,
  ) async {
    final repository = RepositoryFalso();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [contadorRepositoryProvider.overrideWithValue(repository)],
        child: const AplicacionContador(),
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

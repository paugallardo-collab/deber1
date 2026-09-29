import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parte_b_conexion/domain/entities/estado_conexion.dart';
import 'package:parte_b_conexion/domain/usecases/consultar_conexion.dart';
import 'package:parte_b_conexion/domain/usecases/observar_conexion.dart';
import 'package:parte_b_conexion/presentation/pantallas/pantalla_foto.dart';
import 'package:parte_b_conexion/presentation/pantallas/pantalla_stream.dart';

import '../ayudas/repository_falso.dart';

void main() {
  testWidgets('Future conserva la foto hasta consultar otra vez', (
    tester,
  ) async {
    final repository = ConexionRepositoryFalso();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PantallaFoto(consultarConexion: ConsultarConexion(repository)),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('consultar-ahora')));
    await tester.pumpAndSettle();
    expect(find.text('Wi-Fi'), findsOneWidget);

    repository.actual = EstadoConexion.sinConexion;
    await tester.pump();
    expect(find.text('Wi-Fi'), findsOneWidget);

    await tester.tap(find.byKey(const Key('consultar-ahora')));
    await tester.pumpAndSettle();
    expect(find.text('Sin conexion'), findsOneWidget);
    await repository.cerrar();
  });

  testWidgets('Stream actualiza la pantalla sin tocar botones', (tester) async {
    final repository = ConexionRepositoryFalso();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PantallaStream(
            consultarConexion: ConsultarConexion(repository),
            observarConexion: ObservarConexion(repository),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Wi-Fi'), findsOneWidget);

    repository.controlador.add(EstadoConexion.sinConexion);
    await tester.pumpAndSettle();

    expect(find.text('Sin conexion'), findsOneWidget);
    expect(find.text('Cambios recibidos: 2'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    expect(repository.suscripcionCancelada, isTrue);
    await repository.cerrar();
  });
}

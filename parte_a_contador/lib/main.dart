import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/repositories/contador_prefs_repository.dart';
import 'domain/usecases/decrementar.dart';
import 'domain/usecases/incrementar.dart';
import 'domain/usecases/obtener_contador.dart';
import 'presentation/estado/contador_cubit.dart';
import 'presentation/pantallas/pantalla_visor.dart';

void main() {
  Bloc.observer = ObservadorContador();
  final repository = ContadorPrefsRepository();

  runApp(
    AplicacionContador(
      obtenerContador: ObtenerContador(repository),
      incrementar: Incrementar(repository),
      decrementar: Decrementar(repository),
    ),
  );
}

class ObservadorContador extends BlocObserver {
  @override
  void onChange(BlocBase<Object?> bloc, Change<Object?> change) {
    super.onChange(bloc, change);
    if (bloc is ContadorCubit) {
      debugPrint(
        'ContadorCubit: ${change.currentState} -> ${change.nextState}',
      );
    }
  }
}

class AplicacionContador extends StatelessWidget {
  const AplicacionContador({
    required this.obtenerContador,
    required this.incrementar,
    required this.decrementar,
    super.key,
  });

  final ObtenerContador obtenerContador;
  final Incrementar incrementar;
  final Decrementar decrementar;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ContadorCubit(obtenerContador, incrementar, decrementar)..cargar(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Contador con Cubit',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3454D1)),
          scaffoldBackgroundColor: const Color(0xFFF5F7FB),
          useMaterial3: true,
        ),
        home: const PantallaVisor(),
      ),
    );
  }
}

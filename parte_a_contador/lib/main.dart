import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/repositories/contador_prefs_repository.dart';
import 'presentation/estado/contador_provider.dart';
import 'presentation/pantallas/pantalla_visor.dart';

void main() {
  runApp(
    ProviderScope(
      overrides: [
        contadorRepositoryProvider.overrideWithValue(ContadorPrefsRepository()),
      ],
      child: const AplicacionContador(),
    ),
  );
}

class AplicacionContador extends StatelessWidget {
  const AplicacionContador({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Contador con Riverpod',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3454D1)),
        scaffoldBackgroundColor: const Color(0xFFF5F7FB),
        useMaterial3: true,
      ),
      home: const PantallaVisor(),
    );
  }
}

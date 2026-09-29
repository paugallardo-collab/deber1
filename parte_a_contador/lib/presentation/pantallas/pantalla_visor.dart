import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../estado/contador_provider.dart';
import 'pantalla_control.dart';

class PantallaVisor extends ConsumerStatefulWidget {
  const PantallaVisor({super.key});

  @override
  ConsumerState<PantallaVisor> createState() => _PantallaVisorState();
}

class _PantallaVisorState extends ConsumerState<PantallaVisor> {
  @override
  void initState() {
    super.initState();
    Future.microtask(ref.read(contadorProvider.notifier).cargar);
  }

  void _abrirControl() {
    Navigator.of(context)
        .push<void>(MaterialPageRoute(builder: (_) => const PantallaControl()));
  }

  @override
  Widget build(BuildContext context) {
    final contador = ref.watch(contadorProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Contador con Riverpod')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.hub_rounded,
                        size: 52,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Visor',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Contador: $contador',
                        key: const Key('valor-contador'),
                        style: Theme.of(context).textTheme.displaySmall
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'El valor vive en un provider compartido por las pantallas.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 28),
                      FilledButton.icon(
                        key: const Key('ir-control'),
                        onPressed: _abrirControl,
                        icon: const Icon(Icons.tune_rounded),
                        label: const Text('Ir a Control'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../estado/contador_cubit.dart';

class PantallaControl extends StatelessWidget {
  const PantallaControl({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Control')),
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
                      BlocBuilder<ContadorCubit, int>(
                        builder: (context, contador) {
                          return Text(
                            'Contador: $contador',
                            key: const Key('valor-control'),
                            style: Theme.of(context).textTheme.displaySmall
                                ?.copyWith(fontWeight: FontWeight.w700),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FilledButton.tonalIcon(
                            key: const Key('decrementar'),
                            onPressed: context
                                .read<ContadorCubit>()
                                .decrementar,
                            icon: const Icon(Icons.remove),
                            label: const Text('-1'),
                          ),
                          const SizedBox(width: 16),
                          FilledButton.icon(
                            key: const Key('incrementar'),
                            onPressed: context
                                .read<ContadorCubit>()
                                .incrementar,
                            icon: const Icon(Icons.add),
                            label: const Text('+1'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      OutlinedButton.icon(
                        key: const Key('volver'),
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Volver'),
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

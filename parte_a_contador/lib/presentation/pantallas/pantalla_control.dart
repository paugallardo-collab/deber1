import 'package:flutter/material.dart';

import '../../domain/usecases/decrementar.dart';
import '../../domain/usecases/incrementar.dart';

class PantallaControl extends StatefulWidget {
  const PantallaControl({
    required this.valorInicial,
    required this.incrementar,
    required this.decrementar,
    super.key,
  });

  final int valorInicial;
  final Incrementar incrementar;
  final Decrementar decrementar;

  @override
  State<PantallaControl> createState() => _PantallaControlState();
}

class _PantallaControlState extends State<PantallaControl> {
  late int _contador;
  bool _ocupado = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _contador = widget.valorInicial;
  }

  Future<void> _cambiar(Future<int> Function() operacion) async {
    if (_ocupado) return;
    setState(() {
      _ocupado = true;
      _error = null;
    });

    try {
      final valor = await operacion();
      if (!mounted) return;
      setState(() => _contador = valor);
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = 'No se pudo guardar el cambio.');
    } finally {
      if (mounted) setState(() => _ocupado = false);
    }
  }

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
                      Text(
                        'Contador: $_contador',
                        key: const Key('valor-control'),
                        style: Theme.of(context).textTheme.displaySmall
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FilledButton.tonalIcon(
                            key: const Key('decrementar'),
                            onPressed: _ocupado
                                ? null
                                : () => _cambiar(widget.decrementar.call),
                            icon: const Icon(Icons.remove),
                            label: const Text('-1'),
                          ),
                          const SizedBox(width: 16),
                          FilledButton.icon(
                            key: const Key('incrementar'),
                            onPressed: _ocupado
                                ? null
                                : () => _cambiar(widget.incrementar.call),
                            icon: const Icon(Icons.add),
                            label: const Text('+1'),
                          ),
                        ],
                      ),
                      if (_error != null) ...[
                        const SizedBox(height: 16),
                        Text(
                          _error!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ],
                      const SizedBox(height: 28),
                      OutlinedButton.icon(
                        key: const Key('volver'),
                        onPressed: _ocupado
                            ? null
                            : () => Navigator.pop(context, _contador),
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

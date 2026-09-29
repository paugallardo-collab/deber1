import 'package:flutter/material.dart';

import '../../domain/usecases/decrementar.dart';
import '../../domain/usecases/incrementar.dart';
import '../../domain/usecases/obtener_contador.dart';
import 'pantalla_control.dart';

class PantallaVisor extends StatefulWidget {
  const PantallaVisor({
    required this.obtenerContador,
    required this.incrementar,
    required this.decrementar,
    super.key,
  });

  final ObtenerContador obtenerContador;
  final Incrementar incrementar;
  final Decrementar decrementar;

  @override
  State<PantallaVisor> createState() => _PantallaVisorState();
}

class _PantallaVisorState extends State<PantallaVisor> {
  int _contador = 0;
  bool _cargando = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    try {
      final valor = await widget.obtenerContador();
      if (!mounted) return;
      setState(() {
        _contador = valor;
        _cargando = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'No se pudo leer el contador guardado.';
        _cargando = false;
      });
    }
  }

  Future<void> _abrirControl() async {
    final resultado = await Navigator.of(context).push<int>(
      MaterialPageRoute(
        builder: (_) => PantallaControl(
          valorInicial: _contador,
          incrementar: widget.incrementar,
          decrementar: widget.decrementar,
        ),
      ),
    );

    if (!mounted || resultado == null) return;
    setState(() => _contador = resultado);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contador con setState')),
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
                        Icons.looks_one_rounded,
                        size: 52,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Visor',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      if (_cargando)
                        const Padding(
                          padding: EdgeInsets.all(20),
                          child: CircularProgressIndicator(),
                        )
                      else if (_error != null)
                        Text(
                          _error!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        )
                      else
                        Text(
                          'Contador: $_contador',
                          key: const Key('valor-contador'),
                          style: Theme.of(context).textTheme.displaySmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      const SizedBox(height: 12),
                      const Text(
                        'El valor mostrado vive en el State de esta pantalla.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 28),
                      FilledButton.icon(
                        key: const Key('ir-control'),
                        onPressed: _cargando ? null : _abrirControl,
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

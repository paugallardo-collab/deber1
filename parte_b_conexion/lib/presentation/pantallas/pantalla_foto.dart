import 'package:flutter/material.dart';

import '../../domain/entities/estado_conexion.dart';
import '../../domain/usecases/consultar_conexion.dart';
import '../widgets/estado_conexion_view.dart';

class PantallaFoto extends StatefulWidget {
  const PantallaFoto({required this.consultarConexion, super.key});

  final ConsultarConexion consultarConexion;

  @override
  State<PantallaFoto> createState() => _PantallaFotoState();
}

class _PantallaFotoState extends State<PantallaFoto> {
  EstadoConexion? _estado;
  DateTime? _horaConsulta;
  bool _cargando = false;
  String? _error;

  Future<void> _consultar() async {
    if (_cargando) return;
    setState(() {
      _cargando = true;
      _error = null;
    });

    try {
      final estado = await widget.consultarConexion();
      if (!mounted) return;
      setState(() {
        _estado = estado;
        _horaConsulta = DateTime.now();
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = 'No se pudo consultar la conexion.');
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  String _formatearHora(DateTime hora) {
    String dosDigitos(int valor) => valor.toString().padLeft(2, '0');
    return '${dosDigitos(hora.hour)}:${dosDigitos(hora.minute)}:${dosDigitos(hora.second)}';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Una foto del momento',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Esta pantalla solo cambia cuando presionas el boton.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 28),
                    if (_estado == null)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 28),
                        child: Text(
                          'Todavia no hay una consulta',
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    else
                      EstadoConexionView(estado: _estado!),
                    if (_horaConsulta != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        'Consultado a las ${_formatearHora(_horaConsulta!)}',
                        key: const Key('hora-consulta'),
                      ),
                    ],
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
                    FilledButton.icon(
                      key: const Key('consultar-ahora'),
                      onPressed: _cargando ? null : _consultar,
                      icon: _cargando
                          ? const SizedBox.square(
                              dimension: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.camera_alt_outlined),
                      label: const Text('Consultar ahora'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

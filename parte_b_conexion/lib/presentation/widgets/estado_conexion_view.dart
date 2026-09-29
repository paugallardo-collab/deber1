import 'package:flutter/material.dart';

import '../../domain/entities/estado_conexion.dart';

class EstadoConexionView extends StatelessWidget {
  const EstadoConexionView({required this.estado, super.key});

  final EstadoConexion estado;

  @override
  Widget build(BuildContext context) {
    final presentacion = _presentacion(estado);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 104,
          height: 104,
          decoration: BoxDecoration(
            color: presentacion.color.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(presentacion.icono, color: presentacion.color, size: 52),
        ),
        const SizedBox(height: 18),
        Text(
          presentacion.etiqueta,
          key: const Key('estado-conexion'),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: presentacion.color,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  _PresentacionConexion _presentacion(EstadoConexion estado) {
    return switch (estado) {
      EstadoConexion.wifi => const _PresentacionConexion(
        etiqueta: 'Wi-Fi',
        icono: Icons.wifi_rounded,
        color: Color(0xFF147D45),
      ),
      EstadoConexion.datosMoviles => const _PresentacionConexion(
        etiqueta: 'Datos moviles',
        icono: Icons.signal_cellular_alt_rounded,
        color: Color(0xFF147D45),
      ),
      EstadoConexion.sinConexion => const _PresentacionConexion(
        etiqueta: 'Sin conexion',
        icono: Icons.signal_wifi_connected_no_internet_4_rounded,
        color: Color(0xFFB3261E),
      ),
      EstadoConexion.otro => const _PresentacionConexion(
        etiqueta: 'Otra conexion',
        icono: Icons.device_hub_rounded,
        color: Color(0xFF5F6368),
      ),
    };
  }
}

class _PresentacionConexion {
  const _PresentacionConexion({
    required this.etiqueta,
    required this.icono,
    required this.color,
  });

  final String etiqueta;
  final IconData icono;
  final Color color;
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/estado_conexion.dart';
import '../../domain/usecases/consultar_conexion.dart';
import '../../domain/usecases/observar_conexion.dart';
import '../estado/conexion_cubit.dart';
import '../widgets/estado_conexion_view.dart';

class PantallaStream extends StatelessWidget {
  const PantallaStream({
    required this.consultarConexion,
    required this.observarConexion,
    super.key,
  });

  final ConsultarConexion consultarConexion;
  final ObservarConexion observarConexion;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ConexionCubit(consultarConexion, observarConexion)..iniciar(),
      child: const _ContenidoStream(),
    );
  }
}

class _ContenidoStream extends StatefulWidget {
  const _ContenidoStream();

  @override
  State<_ContenidoStream> createState() => _ContenidoStreamState();
}

class _ContenidoStreamState extends State<_ContenidoStream> {
  int _cambiosRecibidos = 0;

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
                child: BlocConsumer<ConexionCubit, EstadoConexion>(
                  listener: (context, estado) {
                    setState(() => _cambiosRecibidos++);
                  },
                  builder: (context, estado) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Una pelicula en vivo',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'El sistema avisa y la pantalla se actualiza sola.',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 28),
                        EstadoConexionView(estado: estado),
                        const SizedBox(height: 18),
                        Text(
                          'Cambios recibidos: $_cambiosRecibidos',
                          key: const Key('contador-cambios'),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

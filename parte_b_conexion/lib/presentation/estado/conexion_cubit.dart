import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/estado_conexion.dart';
import '../../domain/usecases/consultar_conexion.dart';
import '../../domain/usecases/observar_conexion.dart';

class ConexionCubit extends Cubit<EstadoConexion> {
  ConexionCubit(this._consultarConexion, this._observarConexion)
    : super(EstadoConexion.otro);

  final ConsultarConexion _consultarConexion;
  final ObservarConexion _observarConexion;
  StreamSubscription<EstadoConexion>? _suscripcion;
  bool _iniciado = false;

  Future<void> iniciar() async {
    if (_iniciado) return;
    _iniciado = true;

    final estadoActual = await _consultarConexion();
    if (isClosed) return;
    emit(estadoActual);

    _suscripcion = _observarConexion().listen(
      (estado) {
        if (!isClosed) emit(estado);
      },
      onError: (Object _, StackTrace _) {
        if (!isClosed) emit(EstadoConexion.otro);
      },
    );
  }

  @override
  Future<void> close() async {
    await _suscripcion?.cancel();
    return super.close();
  }
}

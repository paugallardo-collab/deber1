import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/decrementar.dart';
import '../../domain/usecases/incrementar.dart';
import '../../domain/usecases/obtener_contador.dart';

class ContadorCubit extends Cubit<int> {
  ContadorCubit(this._obtenerContador, this._incrementar, this._decrementar)
    : super(0);

  final ObtenerContador _obtenerContador;
  final Incrementar _incrementar;
  final Decrementar _decrementar;
  bool _ocupado = false;

  Future<void> cargar() async {
    emit(await _obtenerContador());
  }

  Future<void> incrementar() => _cambiar(_incrementar.call);

  Future<void> decrementar() => _cambiar(_decrementar.call);

  Future<void> _cambiar(Future<int> Function() operacion) async {
    if (_ocupado) return;
    _ocupado = true;
    try {
      emit(await operacion());
    } finally {
      _ocupado = false;
    }
  }
}

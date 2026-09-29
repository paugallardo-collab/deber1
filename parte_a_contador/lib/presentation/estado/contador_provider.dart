import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/contador_repository.dart';
import '../../domain/usecases/decrementar.dart';
import '../../domain/usecases/incrementar.dart';
import '../../domain/usecases/obtener_contador.dart';

final contadorRepositoryProvider = Provider<ContadorRepository>((ref) {
  throw UnimplementedError('El repositorio se configura en main.dart.');
});

final obtenerContadorProvider = Provider<ObtenerContador>((ref) {
  return ObtenerContador(ref.watch(contadorRepositoryProvider));
});

final incrementarProvider = Provider<Incrementar>((ref) {
  return Incrementar(ref.watch(contadorRepositoryProvider));
});

final decrementarProvider = Provider<Decrementar>((ref) {
  return Decrementar(ref.watch(contadorRepositoryProvider));
});

final contadorProvider = NotifierProvider<ContadorNotifier, int>(
  ContadorNotifier.new,
);

class ContadorNotifier extends Notifier<int> {
  bool _ocupado = false;

  @override
  int build() => 0;

  Future<void> cargar() async {
    state = await ref.read(obtenerContadorProvider)();
  }

  Future<void> incrementar() => _cambiar(ref.read(incrementarProvider).call);

  Future<void> decrementar() => _cambiar(ref.read(decrementarProvider).call);

  Future<void> _cambiar(Future<int> Function() operacion) async {
    if (_ocupado) return;
    _ocupado = true;
    try {
      state = await operacion();
    } finally {
      _ocupado = false;
    }
  }
}

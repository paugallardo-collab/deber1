import 'package:flutter_test/flutter_test.dart';
import 'package:parte_a_contador/data/repositories/contador_prefs_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('devuelve cero cuando no existe un valor guardado', () async {
    final repository = ContadorPrefsRepository();

    expect(await repository.leer(), 0);
  });

  test('guarda y recupera el contador', () async {
    final repository = ContadorPrefsRepository();

    await repository.guardar(5);

    expect(await repository.leer(), 5);
  });
}

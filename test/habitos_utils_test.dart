import 'package:flutter_test/flutter_test.dart';
import 'package:lab_habitos_marcela_pineda/utils/habitos_utils.dart';

void main() {
  group('Contar hábitos cumplidos', () {
    test('Debe contar correctamente los hábitos cumplidos', () {
      final cumplidos = [true, false, true, false, true];

      final resultado = contarHabitosCumplidos(cumplidos);

      expect(resultado, 3);
    });

    test('Debe devolver cero cuando ningún hábito está cumplido', () {
      final cumplidos = [false, false, false, false, false];

      final resultado = contarHabitosCumplidos(cumplidos);

      expect(resultado, 0);
    });

    test('Debe contar todos cuando todos están cumplidos', () {
      final cumplidos = [true, true, true, true, true];

      final resultado = contarHabitosCumplidos(cumplidos);

      expect(resultado, 5);
    });
  });
}
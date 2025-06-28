// This is a generated file; do not edit or check into version control.
import 'package:flutter_test/flutter_test.dart';
import 'package:cat_printer_flutter/cat_printer_flutter.dart';

void main() {
  group('Cat Printer Flutter Library Tests', () {
    test('CatPrinterService can be instantiated', () {
      final service = CatPrinterService();
      expect(service, isNotNull);
    });

    test('PrinterModels contains supported models', () {
      final models = PrinterModels.getSupportedModels();
      expect(models, isNotEmpty);
      expect(models, contains('GB01'));
      expect(models, contains('GB02'));
      expect(models, contains('GB03'));
      expect(models, contains('MX05'));
      expect(models, contains('MX06'));
      expect(models, contains('MX10'));
      expect(models, contains('YT01'));
    });

    test('PrinterModels can get model by name', () {
      final gb01 = PrinterModels.getModel('GB01');
      expect(gb01, isNotNull);
      expect(gb01!.name, equals('GB01'));
      expect(gb01.paperWidth, equals(384));
    });

    test('PrinterModels returns null for unsupported model', () {
      final unsupported = PrinterModels.getModel('UNSUPPORTED');
      expect(unsupported, isNull);
    });

    test('PrinterConfig has default values', () {
      final config = PrinterConfig();
      expect(config.energy, equals(4096));
      expect(config.speed, equals(32));
      expect(config.quality, equals(5));
      expect(config.mtu, equals(200));
      expect(config.scanTime, equals(4.0));
      expect(config.connectionTimeout, equals(5.0));
      expect(config.flipH, equals(false));
      expect(config.flipV, equals(false));
    });
  });
}

// Test file untuk menguji deteksi model PPD1 dengan nama device yang memiliki suffix
// Jalankan dengan: dart test_ppd1_detection.dart

import 'lib/models/printer_models.dart';

void main() {
  print('=== Test Deteksi Model PPD1 ===\n');

  // Test cases untuk nama device yang berbeda
  List<String> testDeviceNames = [
    'PPD1', // Exact match
    'PPD1_47E9_BLE', // Dengan suffix BLE
    'PPD1_ABC123', // Dengan suffix lain
    'PPD1-XYZ', // Dengan dash
    'PPD1H', // Model lain
    'PPD1H_47E9_BLE', // PPD1H dengan suffix
    'LuckP_D1_TEST', // Lucky Printer lain
    'UnknownDevice', // Device tidak dikenal
  ];

  for (String deviceName in testDeviceNames) {
    bool isSupported = PrinterModels.isSupported(deviceName);
    PrinterModel? model = PrinterModels.getModel(deviceName);

    print('Device: "$deviceName"');
    print('  Supported: $isSupported');
    if (model != null) {
      print('  Model: ${model.name}');
      print('  Type: ${model.type}');
      print('  Paper Width: ${model.paperWidth}');
    } else {
      print('  Model: null (tidak terdeteksi)');
    }
    print('');
  }

  print('=== Daftar Semua Model Lucky Printer ===\n');
  List<PrinterModel> luckyPrinters =
      PrinterModels.getModelsByType(PrinterType.luckyPrinter);
  print('Total Lucky Printer models: ${luckyPrinters.length}');

  // Tampilkan beberapa model PPD
  List<String> ppdModels = PrinterModels.getSupportedModels()
      .where((name) => name.startsWith('PPD'))
      .toList();
  print('\nModel PPD yang didukung:');
  for (String model in ppdModels) {
    print('  - $model');
  }
}

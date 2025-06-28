# Cat Printer Flutter - New Architecture

## Overview

Arsitektur baru Cat Printer Flutter dirancang untuk memudahkan developer menambahkan model printer baru dengan struktur yang bersih dan terorganisir.

## Struktur Arsitektur

### 1. Command Interface Pattern
```dart
abstract class PrinterCommandInterface {
  List<int> getStartPrintCommand();
  List<int> getDeviceStateCommand();
  // ... other required commands
  
  // Optional commands
  List<int>? getStatusCommand() => null;
  List<int>? getBatteryCommand() => null;
}
```

### 2. Model-Specific Commands

#### Generic Printers (GB01, GB02, GT01, YT01, _ZZ00)
- `lib/services/commands/generic_commands.dart`
- Standard protocol untuk printer Cat generik

#### MX Series (MX05, MX06, MX08, MX09, MX10, MX11)
- Menggunakan `GenericPrinterCommands` 
- Perbedaan ditangani di service layer (feeding problems)

#### GB03 (New Generation)
- `GenericNewPrinterCommands`
- Extends dari generic commands dengan prefix khusus

#### MXW01 (Special Protocol)
- `lib/services/commands/mxw01_commands.dart`
- Protocol khusus dengan format perintah berbeda

### 3. Printer Models Configuration
```dart
enum PrinterType {
  generic,    // Standard printers
  genericNew, // GB03 with compressed data support
  mxSeries,   // MX series with feeding problems
  mxw01,      // MXW01 with special protocol
}

class PrinterModel {
  final String name;
  final int paperWidth;
  final PrinterType type;
  final String txCharacteristic;
  final String rxCharacteristic;
  final String? dataCharacteristic; // Optional for special models
  
  PrinterCommandInterface createCommandInterface() {
    return PrinterCommandFactory.createForModel(this);
  }
}
```

### 4. Factory Pattern
```dart
class PrinterCommandFactory {
  static PrinterCommandInterface createForModel(PrinterModel model) {
    switch (model.type) {
      case PrinterType.generic:
        return GenericPrinterCommands();
      case PrinterType.mxw01:
        return MXW01PrinterCommands();
      // ...
    }
  }
}
```

## Cara Menambahkan Printer Baru

### Langkah 1: Buat Command Class
```dart
// lib/services/commands/new_printer_commands.dart
class NewPrinterCommands implements PrinterCommandInterface {
  @override
  List<int> getStartPrintCommand() {
    // Implementasi khusus printer Anda
    return BaseCommands.makeCommand(0xa3, [0x00]);
  }
  
  // Implement all required methods...
}
```

### Langkah 2: Tambahkan ke PrinterType
```dart
enum PrinterType {
  generic,
  genericNew,
  mxSeries,
  mxw01,
  newPrinter, // <-- Tambahkan ini
}
```

### Langkah 3: Tambahkan ke Model Map
```dart
'NEW_MODEL': PrinterModel(
  name: 'NEW_MODEL',
  paperWidth: 384,
  isNewKind: false,
  problemFeeding: false,
  type: PrinterType.newPrinter,
),
```

### Langkah 4: Update Factory
```dart
case PrinterType.newPrinter:
  return NewPrinterCommands();
```

## Keuntungan Arsitektur Baru

### 1. Separation of Concerns
- Setiap model printer memiliki command class terpisah
- Service layer tidak perlu tahu detail implementasi command
- Base commands dapat digunakan bersama

### 2. Type Safety
- Interface memastikan semua command yang diperlukan diimplementasi
- Compile-time error jika ada method yang terlewat

### 3. Extensibility
- Mudah menambahkan printer baru tanpa mengubah kode yang ada
- Custom commands dapat ditambahkan per model

### 4. Maintainability
- Code duplication berkurang drastis
- Bug fixes hanya perlu dilakukan di satu tempat
- Mudah untuk testing individual components

### 5. Backward Compatibility
- `PrinterCommander` class masih tersedia sebagai compatibility layer
- Existing code tetap berfungsi tanpa perubahan

## File Structure

```
lib/
├── models/
│   └── printer_models.dart          # Model definitions & factory
├── services/
│   ├── commands/
│   │   ├── base_commands.dart       # Shared utilities & constants
│   │   ├── generic_commands.dart    # Standard printer commands
│   │   ├── mxw01_commands.dart      # MXW01 specific commands
│   │   └── example_new_printer.dart # Example for new printers
│   ├── printer_commander.dart       # Compatibility layer
│   └── cat_printer_service.dart     # Main service
```

## Migration Guide

Untuk developer yang sudah menggunakan versi lama:

### Before (Old)
```dart
await _sendCommand(PrinterCommander.getStartPrintCommand());
```

### After (New)
```dart
await _sendCommand(_commands!.getStartPrintCommand());
```

Atau tetap menggunakan compatibility layer:
```dart
await _sendCommand(PrinterCommander.getStartPrintCommand());
```

## Example Usage

```dart
// Service akan otomatis mendeteksi model dan membuat command interface
final service = CatPrinterService();
await service.connect(device);

// Command interface dibuat otomatis berdasarkan model printer
// Tidak perlu lagi hardcode untuk model tertentu
await service.printImage(image);
```

## Testing

Setiap command class dapat di-test secara terpisah:

```dart
test('Generic printer commands', () {
  final commands = GenericPrinterCommands();
  final startCmd = commands.getStartPrintCommand();
  expect(startCmd, isNotEmpty);
});

test('MXW01 printer commands', () {
  final commands = MXW01PrinterCommands();
  final statusCmd = commands.getStatusCommand();
  expect(statusCmd, isNotNull);
});
```

Arsitektur ini memungkinkan Cat Printer Flutter untuk berkembang dengan mudah sambil mempertahankan kualitas code yang tinggi dan kemudahan maintenance. 
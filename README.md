# Cat Printer Flutter

A Flutter library for connecting and printing to Cat Printer via Bluetooth. This library is ported from the Python Cat-Printer implementation with all data and communication protocols preserved.

## Features

- ✅ Scan and detect Cat Printer via Bluetooth
- ✅ Connect to various Cat Printer models (GB01, GB02, GB03, MX05, MX06, MX10, etc.)
- ✅ Print simple text
- ✅ Print images from gallery
- ✅ Configurable printer settings (energy, speed, quality, etc.)
- ✅ Flow control for stable communication
- ✅ Support for all Bluetooth characteristics from Python code

## Supported Printer Models

This library supports all the same models as the Python implementation:
- **GB01** - Paper width: 384px
- **GB02** - Paper width: 384px  
- **GB03** - Paper width: 384px
- **MX05** - Paper width: 384px
- **MX06** - Paper width: 384px
- **MX10** - Paper width: 384px
- **YT01** - Paper width: 384px

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  cat_printer_flutter:
    git:
      url: https://github.com/yanuartrilaksono/Cat-Printer-Flutter.git
      path: build-flutter/cat_printer_flutter
```

Or if you're using it locally:

```yaml
dependencies:
  cat_printer_flutter:
    path: ../path/to/cat_printer_flutter
```

Then run:

```bash
flutter pub get
```

## Usage

### Inisialisasi Service

```dart
import 'package:cat_printer_flutter/cat_printer_flutter.dart';
final CatPrinterService printerService = CatPrinterService();
```

### Scan Printer

```dart
// Scan hanya Cat Printer
tList<BluetoothDevice> printers = await printerService.scanForDevices();

// Scan semua perangkat Bluetooth (opsional)
List<BluetoothDevice> allDevices = await printerService.scanForDevices(showAllDevices: true);

// Mendapatkan total printer yang ditemukan
int total = printers.length;
```

### Mendapatkan Printer yang Terhubung

```dart
BluetoothDevice? connected = printerService.device;
PrinterModel? model = printerService.model;
bool isConnected = printerService.isConnected;
```

### Koneksi ke Printer

```dart
if (printers.isNotEmpty) {
  await printerService.connect(printers.first);
}
```

### Print Teks

```dart
if (printerService.isConnected) {
  await printerService.printText('Hello Cat Printer!');
}
```

### Print Gambar

```dart
import 'package:image/image.dart' as img;
img.Image? image = img.decodeImage(imageBytes);
if (image != null && printerService.isConnected) {
  await printerService.printImage(
    image,
    threshold: 150.0, // opsional, default 128
    energy: 6000,     // opsional, default 6000
    widthScale: 0.8,  // opsional, default 0.8
    heightScale: 0.7, // opsional, default 0.7
  );
}
```

### Print Widget Langsung

```dart
if (printerService.isConnected) {
  await printerService.printWidget(
    Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text('Hello from Widget!', style: TextStyle(fontSize: 24)),
          Icon(Icons.print, size: 48),
        ],
      ),
    ),
    threshold: 150.0, // opsional
    energy: 6000,     // opsional
  );
}
```

### Mendapatkan Status Printer

```dart
if (printerService.isConnected) {
  await printerService.getPrinterStatus();
}
```

---

### Contoh Lengkap

```dart
import 'package:cat_printer_flutter/cat_printer_flutter.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

final CatPrinterService printerService = CatPrinterService();

// Scan printer
List<BluetoothDevice> printers = await printerService.scanForDevices();

// Koneksi
if (printers.isNotEmpty) {
  await printerService.connect(printers.first);
}

// Print teks
if (printerService.isConnected) {
  await printerService.printText('Hello Cat Printer!');
}
```

---

### Advanced Configuration

```dart
// Custom printer configuration
final config = PrinterConfig(
  energy: 6000,        // Energy level (higher = darker)
  speed: 32,           // Print speed
  quality: 5,          // Print quality (1-5)
  scanTime: 10.0,      // Bluetooth scan time
);

// Print with custom settings
await printerService.printText(
  'Custom Print',
  fontSize: 24,
  threshold: 150.0,
  energy: 6000,
  ditherType: 'threshold',
);

// Print image with scaling
await printerService.printImage(
  image,
  threshold: 150.0,
  energy: 6000,
  widthScale: 0.8,
  heightScale: 0.7,
);
```

### Permissions

Make sure to add the required permissions in your app:

#### Android (`android/app/src/main/AndroidManifest.xml`)

```xml
<uses-permission android:name="android.permission.BLUETOOTH" />
<uses-permission android:name="android.permission.BLUETOOTH_ADMIN" />
<uses-permission android:name="android.permission.BLUETOOTH_SCAN" />
<uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
```

#### iOS (`ios/Runner/Info.plist`)

```xml
<key>NSBluetoothAlwaysUsageDescription</key>
<string>This app needs Bluetooth access to connect to Cat Printer</string>
<key>NSBluetoothPeripheralUsageDescription</key>
<string>This app needs Bluetooth access to connect to Cat Printer</string>
```

## API Reference

### CatPrinterService

Main service class for Cat Printer operations.

#### Methods

- `Future<List<BluetoothDevice>> scanForDevices({Duration? timeout, bool showAllDevices = false})` - Scan for Cat Printer devices
- `Future<void> connect(BluetoothDevice device)` - Connect to a printer
- `Future<void> disconnect()` - Disconnect from printer
- `Future<void> printText(String text, {int fontSize = 24, double threshold = 128.0, int energy = 4096, String ditherType = 'threshold'})` - Print text
- `Future<void> printImage(img.Image image, {double threshold = 128.0, int energy = 4096, String ditherType = 'threshold', double widthScale = 0.6, double heightScale = 0.5})` - Print image

#### Properties

- `bool isConnected` - Connection status
- `PrinterModel? model` - Connected printer model
- `PrinterConfig config` - Printer configuration
- `BluetoothDevice? device` - Connected device

### PrinterModels

Utility class for printer model information.

#### Methods

- `static PrinterModel? getModel(String name)` - Get printer model by name
- `static bool isSupported(String name)` - Check if printer model is supported
- `static List<String> getSupportedModels()` - Get list of supported models

### PrinterConfig

Configuration class for printer settings.

#### Properties

- `int energy` - Energy level (default: 4096)
- `int speed` - Print speed (default: 32)
- `int quality` - Print quality (default: 5)
- `int mtu` - Bluetooth MTU size (default: 200)
- `double scanTime` - Scan timeout (default: 4.0)
- `double connectionTimeout` - Connection timeout (default: 5.0)

## Example

See the [example](example/) directory for a complete working example that demonstrates:

- Scanning for Cat Printers
- Connecting and disconnecting
- Printing text with custom settings
- Printing images from gallery
- Real-time configuration adjustments

To run the example:

```bash
cd example
flutter pub get
flutter run
```

## Requirements

- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.5.0)
- Android SDK (for Android)
- Bluetooth Low Energy (BLE) support
- Permissions: Bluetooth, Location (for Android)

## Dependencies

This library depends on:

- `flutter_blue_plus: ^1.14.0` - Bluetooth communication
- `image: ^4.0.17` - Image processing
- `permission_handler: ^11.0.1` - Permissions
- `file_picker: ^6.1.1` - File selection
- `path_provider: ^2.1.1` - File paths

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Original Python Cat-Printer implementation
- Flutter Blue Plus for Bluetooth communication
- Image package for image processing

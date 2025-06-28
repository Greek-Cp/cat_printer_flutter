# Cat Printer Flutter Example

This is an example application demonstrating how to use the `cat_printer_flutter` library to connect and print to Cat Printer devices via Bluetooth.

## Features Demonstrated

- 🔍 **Device Scanning** - Scan for Cat Printer devices or all Bluetooth devices
- 🔗 **Connection Management** - Connect and disconnect from printers
- 📝 **Text Printing** - Print custom text with configurable settings
- 🖼️ **Image Printing** - Select and print images from gallery
- ⚙️ **Real-time Configuration** - Adjust printer settings on the fly
- 📊 **Status Monitoring** - Real-time connection and operation status

## Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- A Cat Printer device (GB01, GB02, GB03, MX05, MX06, MX10, YT01)
- Mobile device with Bluetooth support

### Installation

1. **Navigate to the example directory:**
   ```bash
   cd example
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the application:**
   ```bash
   flutter run
   ```

### Permissions Setup

#### Android

Ensure your `android/app/src/main/AndroidManifest.xml` includes:

```xml
<uses-permission android:name="android.permission.BLUETOOTH" />
<uses-permission android:name="android.permission.BLUETOOTH_ADMIN" />
<uses-permission android:name="android.permission.BLUETOOTH_SCAN" />
<uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
```

#### iOS

Ensure your `ios/Runner/Info.plist` includes:

```xml
<key>NSBluetoothAlwaysUsageDescription</key>
<string>This app needs Bluetooth access to connect to Cat Printer</string>
<key>NSBluetoothPeripheralUsageDescription</key>
<string>This app needs Bluetooth access to connect to Cat Printer</string>
```

## How to Use the Example

### 1. Scanning for Devices

- Open the app
- Toggle "Show all Bluetooth devices" if you want to see all devices (not just Cat Printers)
- Tap "Scan for Printers" or "Scan All Devices"
- Wait for devices to appear in the list

### 2. Connecting to a Printer

- Select a Cat Printer from the scanned devices list
- Tap "Connect" next to the device
- Wait for the connection to establish
- The status will show "Connected" and printer model information

### 3. Printing Text

- Enter your text in the "Text to Print" field
- Optionally adjust advanced settings (energy, threshold, etc.)
- Tap "Print Text"
- The text will be printed on the Cat Printer

### 4. Printing Images

- Tap "Pick & Print Image"
- Select an image from your device's gallery
- The image will be automatically processed and printed
- Adjust image scaling in advanced settings if needed

### 5. Advanced Configuration

- Expand "Advanced Settings (Optional)" to access:
  - **Custom Image Size**: Enable to manually adjust width/height scaling
  - **Energy Level**: Control print darkness (higher = darker)
  - **Threshold**: Adjust image conversion quality

## Code Structure

The example demonstrates the following key concepts:

### Basic Usage

```dart
import 'package:cat_printer_flutter/cat_printer_flutter.dart';

// Create service instance
final CatPrinterService _printerService = CatPrinterService();

// Scan for devices
List<BluetoothDevice> devices = await _printerService.scanForDevices();

// Connect to printer
await _printerService.connect(device);

// Print text
await _printerService.printText('Hello Cat Printer!');

// Print image
await _printerService.printImage(image);
```

### Advanced Configuration

```dart
// Print with custom settings
await _printerService.printText(
  text,
  fontSize: 24,
  threshold: 150.0,
  energy: 6000,
  ditherType: 'threshold',
);

// Print image with scaling
await _printerService.printImage(
  image,
  threshold: 150.0,
  energy: 6000,
  widthScale: 0.8,
  heightScale: 0.7,
);
```

## Troubleshooting

### Bluetooth Issues

- Ensure Bluetooth is enabled on your device
- Grant all required permissions
- Try restarting the app if devices don't appear

### Connection Issues

- Make sure the Cat Printer is powered on
- Ensure the printer is in pairing mode
- Try disconnecting and reconnecting
- Restart the printer if necessary

### Printing Issues

- Check that the printer has paper loaded
- Verify the printer battery level
- Try printing simple text before images
- Adjust energy levels if prints are too light/dark

## Supported Printer Models

This example works with all supported Cat Printer models:

- **GB01** - Paper width: 384px
- **GB02** - Paper width: 384px
- **GB03** - Paper width: 384px
- **MX05** - Paper width: 384px
- **MX06** - Paper width: 384px
- **MX10** - Paper width: 384px
- **YT01** - Paper width: 384px

## Learn More

- [Cat Printer Flutter Library Documentation](../README.md)
- [Flutter Blue Plus Documentation](https://pub.dev/packages/flutter_blue_plus)
- [Image Package Documentation](https://pub.dev/packages/image)

## Contributing

If you find issues with this example or have suggestions for improvements, please feel free to submit a Pull Request or open an Issue.
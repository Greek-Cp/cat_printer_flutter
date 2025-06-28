# Lucky Printer Implementation for Flutter

Implementasi ini menambahkan dukungan untuk printer Lucky Printer ke dalam Flutter Cat Printer library berdasarkan analisis Android SDK dan iOS SDK dari Lucky Printer.

## Model Printer yang Didukung

Berikut adalah model-model Lucky Printer yang telah ditambahkan:

### Model Utama
- **LuckP_D1** - Model dasar Lucky Printer
- **A2** - Model A series
- **DP_D1** - Model DP series
- **MiniPocketPrinter** - Printer saku mini

### D Series
- **D11, D101, D110** - D1xx series
- **D201, D210** - D2xx series  
- **D301, D310** - D3xx series

### H Series
- **H1, H2, H3, H4, H5** - H1-H5 series
- **H6, H7, H8, H9, H10** - H6-H10 series

### P Series
- **P1, P2, P3, P4, P5** - P1-P5 series
- **P6, P7, P8, P9, P10** - P6-P10 series

## Fitur yang Didukung

### Command Interface Standar
- ✅ Start Print
- ✅ Get Device State
- ✅ Set DPI/Width
- ✅ Set Energy (Density)
- ✅ Set Speed
- ✅ Apply Energy
- ✅ Update Device
- ✅ Start/End Lattice
- ✅ Feed/Retract Paper
- ✅ Draw Bitmap
- ✅ Get Status
- ✅ Get Battery
- ✅ Get Version

### Command Khusus Lucky Printer
- ✅ Get Model
- ✅ Get Serial Number
- ✅ Get Device Boot Info
- ✅ Get/Set Shutdown Time
- ✅ Get/Set Density
- ✅ Get/Set Speed
- ✅ Enable/Disable Printer
- ✅ Stop Print Job
- ✅ Wakeup
- ✅ Print Line Dots
- ✅ Print Reverse Line Dots
- ✅ Printer Position
- ✅ Set Width
- ✅ Set Heating Level
- ✅ Set Printer Mode
- ✅ Set Paper Type
- ✅ Adjust Position Auto
- ✅ Set Recovery
- ✅ Get/Set Time Format
- ✅ Mark Print Last
- ✅ Send Custom Command

## Struktur Command

Lucky Printer menggunakan struktur command yang berbeda dari Cat Printer:

### Format Command Umum
```
[0x10, 0xFF, command_byte, data...]
```

### Contoh Command
- **Get Model**: `[0x10, 0xFF, 0x20, 0xF0]`
- **Get Battery**: `[0x10, 0xFF, 0x50, 0xF1]`
- **Set Density**: `[0x10, 0xFF, 0x10, 0x00, density]`
- **Enable Printer**: `[0x10, 0xFF, 0xF1, mode]`
- **Wakeup**: `[0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]`

## Cara Penggunaan

### 1. Import Library
```dart
import 'package:cat_printer_flutter/cat_printer_flutter.dart';
```

### 2. Deteksi Model Printer
```dart
// Cek apakah model didukung
if (PrinterModels.isSupported('LuckP_D1')) {
  PrinterModel? model = PrinterModels.getModel('LuckP_D1');
  print('Model: ${model?.name}, Type: ${model?.type}');
}

// Dapatkan semua model Lucky Printer
List<PrinterModel> luckyPrinters = PrinterModels.getModelsByType(PrinterType.luckyPrinter);
print('Lucky Printer models: ${luckyPrinters.map((m) => m.name).toList()}');
```

### 3. Buat Command Interface
```dart
PrinterModel model = PrinterModels.getModel('LuckP_D1')!;
PrinterCommandInterface commands = PrinterCommandFactory.createForModel(model);

// Gunakan sebagai LuckyPrinterCommands untuk akses command khusus
if (commands is LuckyPrinterCommands) {
  LuckyPrinterCommands luckyCommands = commands;
  
  // Command khusus Lucky Printer
  List<int> modelCmd = luckyCommands.getModelCommand();
  List<int> serialCmd = luckyCommands.getSerialNumberCommand();
  List<int> densityCmd = luckyCommands.getDensityCommand();
}
```

### 4. Contoh Penggunaan Command
```dart
// Command standar
List<int> startPrint = commands.getStartPrintCommand();
List<int> getStatus = commands.getDeviceStateCommand();
List<int> setBattery = commands.getBatteryCommand();

// Command khusus Lucky Printer
if (commands is LuckyPrinterCommands) {
  LuckyPrinterCommands lucky = commands;
  
  // Set density (0-255)
  List<int> setDensity = lucky.setDensityCommand(128);
  
  // Set speed (0-255)
  List<int> setSpeed = lucky.setSpeedCommand(64);
  
  // Set shutdown time (dalam menit)
  List<int> setShutdown = lucky.setShutdownTimeCommand(30);
  
  // Set paper type
  List<int> setPaper = lucky.getSetPaperTypeCommand(0x01, 0x02);
  
  // Set time format dengan DateTime
  DateTime now = DateTime.now();
  List<int> setTime = lucky.getSetTimeFormatCommand(1, now);
}
```

## Perbedaan dengan Cat Printer

| Aspek | Cat Printer | Lucky Printer |
|-------|-------------|---------------|
| Command Format | `[magic, cmd, len, data, crc, end]` | `[0x10, 0xFF, cmd, data...]` |
| Wakeup | Single byte | 12 zero bytes |
| Density Control | Energy setting | Direct density value |
| Paper Control | Generic feed | Line dots control |
| Status Response | Structured | Raw bytes |
| Time Setting | Not supported | Full DateTime support |

## Bluetooth Characteristics

**PENTING**: Lucky Printer menggunakan karakteristik Bluetooth yang BERBEDA dari Cat Printer!

### Lucky Printer Characteristics:
- **Service UUID**: `0000ff00-0000-1000-8000-00805f9b34fb`
- **TX Characteristic (Write)**: `0000ff02-0000-1000-8000-00805f9b34fb`
- **RX Characteristic (Notify)**: `0000ff01-0000-1000-8000-00805f9b34fb`
- **Credit Characteristic (Notify)**: `0000ff03-0000-1000-8000-00805f9b34fb`

### Cat Printer Characteristics (untuk perbandingan):
- **Service UUID**: `0000ae30-0000-1000-8000-00805f9b34fb`
- **TX Characteristic**: `0000ae01-0000-1000-8000-00805f9b34fb`
- **RX Characteristic**: `0000ae02-0000-1000-8000-00805f9b34fb`
- **Data Characteristic**: `0000ae03-0000-1000-8000-00805f9b34fb`

### Troubleshooting Connection Error
Jika Anda mendapat error "Required characteristic not found":
1. **Pastikan menggunakan Lucky Printer**, bukan Cat Printer
2. **Periksa service UUID** - harus dimulai dengan `0000ff00`
3. **Restart Bluetooth** dan coba scan ulang
4. **Periksa log** untuk melihat karakteristik yang ditemukan

## Troubleshooting

### Masalah Koneksi
1. **Pastikan Bluetooth aktif** dan device dalam mode pairing
2. **Periksa permission** Bluetooth di aplikasi
3. **Restart Bluetooth** jika scanning tidak menemukan device
4. **Coba scan ulang** beberapa kali

### Deteksi Model Printer
Sistem sekarang mendukung **deteksi otomatis model** berdasarkan prefix nama:
- `PPD1_47E9_BLE` → terdeteksi sebagai model `PPD1`
- `LuckP_D1_ABC123` → terdeteksi sebagai model `LuckP_D1`
- `DP_A2-XYZ` → terdeteksi sebagai model `DP_A2`

Jika printer tidak terdeteksi:
1. **Periksa nama device** di hasil scanning
2. **Pastikan prefix nama** sesuai dengan model yang didukung
3. **Gunakan mode "Show all devices"** untuk melihat semua device

### Masalah Printing
1. **Periksa energy level** - sesuaikan jika print terlalu terang/gelap
2. **Cek paper** - pastikan kertas terpasang dengan benar
3. **Restart printer** jika tidak merespons

### Debug Mode
```dart
// Enable debug mode
printerConfig.dryRun = true; // Test mode tanpa print
printerConfig.dump = true;   // Log semua command
```

## Pengembangan Lebih Lanjut

Untuk menambahkan model Lucky Printer baru:

1. Tambahkan model ke `PrinterModels.models` di `printer_models.dart`
2. Tentukan `PrinterType.luckyPrinter` sebagai type
3. Sesuaikan `paperWidth` jika berbeda dari 384
4. Test dengan command dasar terlebih dahulu

Untuk menambahkan command baru:

1. Analisis command dari Android/iOS SDK
2. Tambahkan method ke `LuckyPrinterCommands`
3. Dokumentasikan format dan parameter
4. Test dengan hardware asli

## Referensi

- Android SDK: `lucky_printer_sdk/device/`
- iOS SDK: `LuckyBleDemo/`
- Base implementation: `base_commands.dart`
- Command analysis: Berdasarkan `INormalDeviceOperation.java` dan `BaseFunc` protocol
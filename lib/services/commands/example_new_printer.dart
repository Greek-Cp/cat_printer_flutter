// Example: How to Add a New Printer Model
// This file demonstrates how developers can easily add support for new printer models

import '../../models/printer_models.dart';
import 'base_commands.dart';

// Step 1: Create a command class for your new printer
class NewPrinterCommands implements PrinterCommandInterface {
  @override
  List<int> getStartPrintCommand() {
    // Implement your printer's specific start print command
    return BaseCommands.makeCommand(0xa3, BaseCommands.intToBytes(0x00));
  }

  @override
  List<int> getDeviceStateCommand() {
    // Implement your printer's device state command
    return BaseCommands.makeCommand(0xa3, BaseCommands.intToBytes(0x00));
  }

  @override
  List<int> getSetDpiCommand() {
    // Implement your printer's DPI setting command
    return BaseCommands.makeCommand(0xa4, BaseCommands.intToBytes(50));
  }

  @override
  List<int> getSetEnergyCommand(int energy) {
    // Implement your printer's energy setting command
    return BaseCommands.makeCommand(
        0xaf, BaseCommands.intToBytes(energy, length: 2));
  }

  @override
  List<int> getSetSpeedCommand(int speed) {
    // Implement your printer's speed setting command
    return BaseCommands.makeCommand(0xbd, BaseCommands.intToBytes(speed));
  }

  @override
  List<int> getApplyEnergyCommand() {
    // Implement your printer's apply energy command
    return BaseCommands.makeCommand(0xbe, BaseCommands.intToBytes(0x01));
  }

  @override
  List<int> getUpdateDeviceCommand() {
    // Implement your printer's update device command
    return BaseCommands.makeCommand(0xa9, BaseCommands.intToBytes(0x00));
  }

  @override
  List<int> getStartLatticeCommand() {
    // Implement your printer's start lattice command
    return BaseCommands.makeCommand(0xa6,
        [0xaa, 0x55, 0x17, 0x38, 0x44, 0x5f, 0x5f, 0x5f, 0x44, 0x38, 0x2c]);
  }

  @override
  List<int> getEndLatticeCommand() {
    // Implement your printer's end lattice command
    return BaseCommands.makeCommand(0xa6,
        [0xaa, 0x55, 0x17, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x17]);
  }

  @override
  List<int> getFeedPaperCommand(int pixels) {
    // Implement your printer's feed paper command
    return BaseCommands.makeCommand(
        0xa1, BaseCommands.intToBytes(pixels, length: 2));
  }

  @override
  List<int> getRetractPaperCommand(int pixels) {
    // Implement your printer's retract paper command
    return BaseCommands.makeCommand(
        0xa0, BaseCommands.intToBytes(pixels, length: 2));
  }

  @override
  List<int> getDrawBitmapCommand(List<int> bitmapData) {
    // Implement your printer's draw bitmap command
    return BaseCommands.makeCommand(0xa2, bitmapData);
  }

  // Optional commands - implement if your printer supports them
  @override
  List<int>? getStatusCommand() {
    // Return null if not supported, or implement if supported
    return BaseCommands.makeCommand(0xb1, [0x00]);
  }

  @override
  List<int>? getBatteryCommand() {
    // Return null if not supported, or implement if supported
    return null;
  }

  @override
  List<int>? getVersionCommand() {
    // Return null if not supported, or implement if supported
    return BaseCommands.makeCommand(0xb2, [0x00]);
  }

  // Add any custom commands specific to your printer
  List<int> getCustomCommand(List<int> data) {
    return BaseCommands.makeCommand(0xcc, data);
  }
}

/* 
Step 2: Add your printer model to the PrinterModels class in printer_models.dart:

Add a new PrinterType enum value:
enum PrinterType {
  generic,
  genericNew,
  mxSeries,
  mxw01,
  newPrinter,  // <-- Add this
}

Add your printer model to the models map:
'NEW_PRINTER_MODEL': PrinterModel(
  name: 'NEW_PRINTER_MODEL',
  paperWidth: 384,  // Your printer's paper width in pixels
  isNewKind: false,  // or true if it supports compressed data
  problemFeeding: false,  // or true if it has feeding problems
  type: PrinterType.newPrinter,
  // Optionally override characteristics if different:
  // txCharacteristic: 'your-custom-tx-uuid',
  // rxCharacteristic: 'your-custom-rx-uuid',
  // dataCharacteristic: 'your-custom-data-uuid', // if needed
),

Update the PrinterCommandFactory:
case PrinterType.newPrinter:
  return NewPrinterCommands();

Step 3: That's it! Your new printer is now supported.

The service will automatically:
- Detect your printer during scanning
- Create the appropriate command interface
- Use your custom commands for all operations
- Handle the printer-specific protocol

Benefits of this architecture:
1. Clean separation of concerns
2. Easy to add new printers
3. Type-safe command interfaces
4. No code duplication
5. Backward compatibility maintained
6. Each printer model is self-contained
*/ 
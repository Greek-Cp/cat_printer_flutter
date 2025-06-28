// MXW01 Cat Printer Commands - Special protocol implementation
// For MXW01 model with different command format

import '../../models/printer_models.dart';
import 'base_commands.dart';

class MXW01PrinterCommands implements PrinterCommandInterface {
  // MXW01 specific command constants
  static const int getStatus = 0xa1;
  static const int printIntensity = 0xa2;
  static const int ejectPaper = 0xa3;
  static const int retractPaperMXW01 = 0xa4;
  static const int queryCount = 0xa7;
  static const int print = 0xa9;
  static const int printComplete = 0xaa;
  static const int batteryLevel = 0xab;
  static const int cancelPrint = 0xac;
  static const int printDataFlush = 0xad;
  static const int unknownAE = 0xae;
  static const int getPrintType = 0xb0;
  static const int getVersion = 0xb1;
  static const int unknownB2 = 0xb2;
  static const int unknownB3 = 0xb3;

  /// Create MXW01 command format: [0x22, 0x21, commandId, 0x00, dataLength(2 bytes), data, crc8, 0xFF]
  static List<int> makeMXW01Command(int commandId, List<int> commandData) {
    List<int> command = List.filled(8 + commandData.length, 0);

    command[0] = 0x22;
    command[1] = 0x21;
    command[2] = commandId;
    command[3] = 0x00;
    command[4] = commandData.length & 0xFF; // Little endian
    command[5] = (commandData.length >> 8) & 0xFF;

    // Copy command data
    for (int i = 0; i < commandData.length; i++) {
      command[6 + i] = commandData[i];
    }

    // Calculate CRC8 for command data only
    command[6 + commandData.length] = BaseCommands.calculateCrc8(commandData);
    command[7 + commandData.length] = 0xFF;

    return command;
  }

  // MXW01 doesn't use standard printer commands, but we provide minimal implementations
  @override
  List<int> getStartPrintCommand() {
    // MXW01 doesn't have a traditional start print command
    // This is handled differently in the printing process
    return [];
  }

  @override
  List<int> getDeviceStateCommand() {
    return getStatusCommand() ?? [];
  }

  @override
  List<int> getSetDpiCommand() {
    // MXW01 doesn't use DPI setting in the same way
    return [];
  }

  @override
  List<int> getSetEnergyCommand(int energy) {
    // Use print intensity instead
    if (energy > 100) energy = 100;
    return getPrintIntensityCommand(energy);
  }

  @override
  List<int> getSetSpeedCommand(int speed) {
    // MXW01 doesn't support speed setting in the same way
    return [];
  }

  @override
  List<int> getApplyEnergyCommand() {
    // Not applicable for MXW01
    return [];
  }

  @override
  List<int> getUpdateDeviceCommand() {
    // Not applicable for MXW01
    return [];
  }

  @override
  List<int> getStartLatticeCommand() {
    // Not applicable for MXW01
    return [];
  }

  @override
  List<int> getEndLatticeCommand() {
    // Not applicable for MXW01
    return [];
  }

  @override
  List<int> getFeedPaperCommand(int pixels) {
    return getEjectPaperCommand(pixels);
  }

  @override
  List<int> getRetractPaperCommand(int pixels) {
    return getMXW01RetractPaperCommand(pixels);
  }

  @override
  List<int> getDrawBitmapCommand(List<int> bitmapData) {
    // MXW01 handles bitmap data differently - sent to data characteristic
    // This is managed in the service layer
    return [];
  }

  @override
  List<int> getStatusCommand() {
    return makeMXW01Command(getStatus, [0x00]);
  }

  @override
  List<int> getVersionCommand() {
    return makeMXW01Command(getVersion, [0x00]);
  }

  @override
  List<int> getBatteryCommand() {
    return makeMXW01Command(batteryLevel, [0x00]);
  }

  // MXW01 specific commands
  /// Set print intensity command for MXW01
  List<int> getPrintIntensityCommand(int intensity) {
    if (intensity > 100) intensity = 100;
    return makeMXW01Command(printIntensity, [intensity]);
  }

  /// Eject paper command for MXW01
  List<int> getEjectPaperCommand(int lineCount) {
    return makeMXW01Command(
        ejectPaper, [lineCount & 0xFF, (lineCount >> 8) & 0xFF]);
  }

  /// Retract paper command for MXW01
  List<int> getMXW01RetractPaperCommand(int lineCount) {
    return makeMXW01Command(
        retractPaperMXW01, [lineCount & 0xFF, (lineCount >> 8) & 0xFF]);
  }

  /// Print command for MXW01
  List<int> getPrintCommand(int lineCount, int printMode) {
    return makeMXW01Command(
        print, [lineCount & 0xFF, (lineCount >> 8) & 0xFF, 0x30, printMode]);
  }

  /// Print data flush command for MXW01
  List<int> getPrintDataFlushCommand() {
    return makeMXW01Command(printDataFlush, [0x00]);
  }

  /// Query count command for MXW01
  List<int> getQueryCountCommand() {
    return makeMXW01Command(queryCount, [0x00]);
  }

  /// Print complete command for MXW01
  List<int> getPrintCompleteCommand() {
    return makeMXW01Command(printComplete, [0x00]);
  }

  /// Cancel print command for MXW01
  List<int> getCancelPrintCommand() {
    return makeMXW01Command(cancelPrint, [0x00]);
  }
}

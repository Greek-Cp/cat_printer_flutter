// Cat Printer Commander - Simplified interface using new command structure
// This file is now a compatibility layer for the new architecture

import '../models/printer_models.dart';
import 'commands/base_commands.dart';
import 'commands/generic_commands.dart';
import 'commands/mxw01_commands.dart';

class PrinterCommander {
  // Bluetooth characteristics - kept for backward compatibility
  static const String txCharacteristic = BaseCommands.txCharacteristic;
  static const String rxCharacteristic = BaseCommands.rxCharacteristic;
  static const String dataCharacteristic = BaseCommands.dataCharacteristic;

  // Data flow control constants - kept for backward compatibility
  static const List<int> dataFlowPause = BaseCommands.dataFlowPause;
  static const List<int> dataFlowResume = BaseCommands.dataFlowResume;

  // Static helper methods for backward compatibility
  static int calculateCrc8(List<int> data) {
    return BaseCommands.calculateCrc8(data);
  }

  static List<int> makeCommand(int command, List<int> data) {
    return BaseCommands.makeCommand(command, data);
  }

  static List<int> intToBytes(int value, {int length = 1}) {
    return BaseCommands.intToBytes(value, length: length);
  }

  // Generic commands using the new structure
  static List<int> getStartPrintCommand() {
    return GenericPrinterCommands().getStartPrintCommand();
  }

  static List<int> getStartPrintNewCommand() {
    return GenericNewPrinterCommands().getStartPrintCommand();
  }

  static List<int> getApplyEnergyCommand() {
    return GenericPrinterCommands().getApplyEnergyCommand();
  }

  static List<int> getDeviceStateCommand() {
    return GenericPrinterCommands().getDeviceStateCommand();
  }

  static List<int> getSetDpiAs200Command() {
    return GenericPrinterCommands().getSetDpiCommand();
  }

  static List<int> getStartLatticeCommand() {
    return GenericPrinterCommands().getStartLatticeCommand();
  }

  static List<int> getEndLatticeCommand() {
    return GenericPrinterCommands().getEndLatticeCommand();
  }

  static List<int> getSetEnergyCommand(int amount) {
    return GenericPrinterCommands().getSetEnergyCommand(amount);
  }

  static List<int> getSetSpeedCommand(int value) {
    return GenericPrinterCommands().getSetSpeedCommand(value);
  }

  static List<int> getFeedPaperCommand(int pixels) {
    return GenericPrinterCommands().getFeedPaperCommand(pixels);
  }

  static List<int> getRetractPaperCommand(int pixels) {
    return GenericPrinterCommands().getRetractPaperCommand(pixels);
  }

  static List<int> getDrawBitmapCommand(List<int> bitmapData) {
    return GenericPrinterCommands().getDrawBitmapCommand(bitmapData);
  }

  static List<int> getUpdateDeviceCommand() {
    return GenericPrinterCommands().getUpdateDeviceCommand();
  }

  static List<int> getSetQualityCommand(int quality) {
    return GenericPrinterCommands().getSetQualityCommand(quality);
  }

  static List<int> getDrawingModeCommand(int mode) {
    return GenericPrinterCommands().getDrawingModeCommand(mode);
  }

  // MXW01 specific commands - kept for backward compatibility
  static List<int> getMXW01StatusCommand() {
    return MXW01PrinterCommands().getStatusCommand() ?? [];
  }

  static List<int> getMXW01VersionCommand() {
    return MXW01PrinterCommands().getVersionCommand() ?? [];
  }

  static List<int> getMXW01BatteryCommand() {
    return MXW01PrinterCommands().getBatteryCommand() ?? [];
  }

  static List<int> getMXW01PrintIntensityCommand(int intensity) {
    return MXW01PrinterCommands().getPrintIntensityCommand(intensity);
  }

  static List<int> getMXW01EjectPaperCommand(int lineCount) {
    return MXW01PrinterCommands().getEjectPaperCommand(lineCount);
  }

  static List<int> getMXW01RetractPaperCommand(int lineCount) {
    return MXW01PrinterCommands().getMXW01RetractPaperCommand(lineCount);
  }

  static List<int> getMXW01PrintCommand(int lineCount, int printMode) {
    return MXW01PrinterCommands().getPrintCommand(lineCount, printMode);
  }

  static List<int> getMXW01PrintDataFlushCommand() {
    return MXW01PrinterCommands().getPrintDataFlushCommand();
  }

  // Legacy CRC8 function name - kept for compatibility
  static int crc8(List<int> data) {
    return calculateCrc8(data);
  }
}

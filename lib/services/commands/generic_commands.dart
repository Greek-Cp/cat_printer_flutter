// Generic Cat Printer Commands - Standard protocol implementation
// For models: GB01, GB02, GT01, YT01, _ZZ00

import '../../models/printer_models.dart';
import 'base_commands.dart';

class GenericPrinterCommands implements PrinterCommandInterface {
  @override
  List<int> getStartPrintCommand() {
    return BaseCommands.makeCommand(
        BaseCommands.startPrint, BaseCommands.intToBytes(0x00));
  }

  @override
  List<int> getDeviceStateCommand() {
    return BaseCommands.makeCommand(
        BaseCommands.getDeviceState, BaseCommands.intToBytes(0x00));
  }

  @override
  List<int> getSetDpiCommand() {
    return BaseCommands.makeCommand(
        BaseCommands.setDpiAs200, BaseCommands.intToBytes(50));
  }

  @override
  List<int> getSetEnergyCommand(int energy) {
    return BaseCommands.makeCommand(
        BaseCommands.setEnergy, BaseCommands.intToBytes(energy, length: 2));
  }

  @override
  List<int> getSetSpeedCommand(int speed) {
    return BaseCommands.makeCommand(
        BaseCommands.setSpeed, BaseCommands.intToBytes(speed));
  }

  @override
  List<int> getApplyEnergyCommand() {
    return BaseCommands.makeCommand(
        BaseCommands.applyEnergy, BaseCommands.intToBytes(0x01));
  }

  @override
  List<int> getUpdateDeviceCommand() {
    return BaseCommands.makeCommand(
        BaseCommands.updateDevice, BaseCommands.intToBytes(0x00));
  }

  @override
  List<int> getStartLatticeCommand() {
    return BaseCommands.makeCommand(BaseCommands.startLattice,
        [0xaa, 0x55, 0x17, 0x38, 0x44, 0x5f, 0x5f, 0x5f, 0x44, 0x38, 0x2c]);
  }

  @override
  List<int> getEndLatticeCommand() {
    return BaseCommands.makeCommand(BaseCommands.endLattice,
        [0xaa, 0x55, 0x17, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x17]);
  }

  @override
  List<int> getFeedPaperCommand(int pixels) {
    return BaseCommands.makeCommand(
        BaseCommands.feedPaper, BaseCommands.intToBytes(pixels, length: 2));
  }

  @override
  List<int> getRetractPaperCommand(int pixels) {
    return BaseCommands.makeCommand(
        BaseCommands.retractPaper, BaseCommands.intToBytes(pixels, length: 2));
  }

  @override
  List<int> getDrawBitmapCommand(List<int> bitmapData) {
    return BaseCommands.makeCommand(BaseCommands.drawBitmap, bitmapData);
  }

  // Generic printers don't support these commands
  @override
  List<int>? getStatusCommand() => null;

  @override
  List<int>? getBatteryCommand() => null;

  @override
  List<int>? getVersionCommand() => null;

  /// Set quality command
  List<int> getSetQualityCommand(int quality) {
    return BaseCommands.makeCommand(
        BaseCommands.setQuality, BaseCommands.intToBytes(quality));
  }

  /// Drawing mode command
  List<int> getDrawingModeCommand(int mode) {
    return BaseCommands.makeCommand(
        BaseCommands.drawingMode, BaseCommands.intToBytes(mode));
  }
}

// For GB03 model that supports compressed data and new protocol
class GenericNewPrinterCommands extends GenericPrinterCommands {
  @override
  List<int> getStartPrintCommand() {
    List<int> command = super.getStartPrintCommand();
    return [0x12] + command; // Add prefix for new printers
  }
}

// For MX series with feeding problems (MX05, MX06, MX08, MX09, MX10, MX11)
class MXSeriesPrinterCommands extends GenericPrinterCommands {
  // MX series uses the same commands as generic printers
  // The difference is handled in the service layer for feeding behavior
}

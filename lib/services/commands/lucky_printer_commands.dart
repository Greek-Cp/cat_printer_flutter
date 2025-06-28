// Lucky Printer Commands - Implementation for Lucky Printer SDK models
// Based on Android SDK analysis from lucky_printer_sdk

import '../../models/printer_models.dart';
import 'base_commands.dart';

class LuckyPrinterCommands implements PrinterCommandInterface {
  // Lucky Printer specific command constants (from Android SDK analysis)
  static const int cmdGetModel = 0x10FF20F0; // [16, 255, 32, 240]
  static const int cmdGetSN = 0x10FF20F2; // [16, 255, 32, 242]
  static const int cmdGetVersion = 0x10FF20F1; // [16, 255, 32, 241]
  static const int cmdGetBattery = 0x10FF50F1; // [16, 255, 80, 241]
  static const int cmdGetStatus = 0x10FF40; // [16, 255, 64]
  static const int cmdGetDensity = 0x10FF11; // [16, 255, 17]
  static const int cmdSetDensity = 0x10FF1000; // [16, 255, 16, 0, density]
  static const int cmdGetSpeed = 0x10FF20A0; // [16, 255, 32, 160]
  static const int cmdSetSpeed = 0x10FFC0; // [16, 255, 192, speed]
  static const int cmdGetShutTime = 0x10FF13; // [16, 255, 19]
  static const int cmdSetShutTime =
      0x10FF12; // [16, 255, 18, high_byte, low_byte]
  static const int cmdEnablePrinter = 0x10FFF1; // [16, 255, 241, mode]
  static const int cmdStopPrint = 0x10FFF145; // [16, 255, 241, 69]
  static const int cmdWakeup =
      0x0C; // [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0] (12 zeros)
  static const int cmdPrintLineDots = 0x1B4A; // [27, 74, dots]
  static const int cmdPrintReverseLineDots = 0x1F1111; // [31, 17, 17, dots]
  static const int cmdPrinterPosition = 0x1D0C; // [29, 12]
  static const int cmdSetWidth = 0x10FF15; // [16, 255, 21, low_byte, high_byte]
  static const int cmdSetHeatingLevel = 0x1F7001; // [31, 112, 1, level]
  static const int cmdSetPrinterMode = 0x10FF3027; // [16, 255, 48, 39, mode]
  static const int cmdSetPaperType = 0x1F80; // [31, 128, type1, type2]
  static const int cmdAdjustPosition = 0x1F11; // [31, 17, position]
  static const int cmdSetRecovery = 0x10FF04; // [16, 255, 4]
  static const int cmdGetTimeFormat = 0x10FFB0; // [16, 255, 176]
  static const int cmdSetTimeFormat =
      0x10FF534A; // [16, 255, 83, 74, format, ...time_data]
  static const int cmdMarkPrintLast = 0x1BBBBB; // [27, 187, 187]

  @override
  List<int> getStartPrintCommand() {
    // Enable printer command
    return [0x10, 0xFF, 0xF1, 0x03]; // Enable with mode 3
  }

  @override
  List<int> getDeviceStateCommand() {
    // Get printer status
    return [0x10, 0xFF, 0x40];
  }

  @override
  List<int> getSetDpiCommand() {
    // Lucky printers typically use fixed DPI, return width setting
    return [0x10, 0xFF, 0x15, 0x80, 0x01]; // Set width to 384 (0x0180)
  }

  @override
  List<int> getSetEnergyCommand(int energy) {
    // Set density (energy equivalent in Lucky Printer)
    return [0x10, 0xFF, 0x10, 0x00, energy & 0xFF];
  }

  @override
  List<int> getSetSpeedCommand(int speed) {
    return [0x10, 0xFF, 0xC0, speed & 0xFF];
  }

  @override
  List<int> getApplyEnergyCommand() {
    // Wakeup command to apply settings
    return getWakeupCommand();
  }

  @override
  List<int> getUpdateDeviceCommand() {
    // Recovery command
    return [0x10, 0xFF, 0x04];
  }

  @override
  List<int> getStartLatticeCommand() {
    // Position command for start
    return [0x1D, 0x0C];
  }

  @override
  List<int> getEndLatticeCommand() {
    // Print line dots for end - FIXED: Use proper end line dots calculation
    // PPD1 uses 80 dots (384 width), other models use 120 dots
    return [0x1B, 0x4A, 0x50]; // Print 80 dots for PPD1
  }

  @override
  List<int> getFeedPaperCommand(int pixels) {
    // Print line dots
    return [0x1B, 0x4A, pixels & 0xFF];
  }

  @override
  List<int> getRetractPaperCommand(int pixels) {
    // Print reverse line dots
    return [0x1F, 0x11, 0x11, pixels & 0xFF];
  }

  @override
  List<int> getDrawBitmapCommand(List<int> bitmapData) {
    // CRITICAL FIX: PPD1 Java SDK uses sendBitmap() which sends bitmap data directly
    // without special command wrapper - just raw bitmap data
    // This matches the BaseNormalDevice.sendBitmap() implementation

    // For line-by-line printing, we send the bitmap data as-is
    // The printer expects raw bitmap data for each line
    return List.from(bitmapData);
  }

  @override
  List<int> getStatusCommand() {
    return [0x10, 0xFF, 0x40];
  }

  @override
  List<int> getBatteryCommand() {
    return [0x10, 0xFF, 0x50, 0xF1];
  }

  @override
  List<int> getVersionCommand() {
    return [0x10, 0xFF, 0x20, 0xF1];
  }

  // Lucky Printer specific commands

  /// Get device model command
  List<int> getModelCommand() {
    return [0x10, 0xFF, 0x20, 0xF0];
  }

  /// Get device serial number command
  List<int> getSerialNumberCommand() {
    return [0x10, 0xFF, 0x20, 0xF2];
  }

  /// Get device boot info command
  List<int> getDeviceBootCommand() {
    return [0x10, 0xFF, 0x20, 0xEF];
  }

  /// Get shutdown time command
  List<int> getShutdownTimeCommand() {
    return [0x10, 0xFF, 0x13];
  }

  /// Set shutdown time command
  List<int> setShutdownTimeCommand(int minutes) {
    int highByte = (minutes ~/ 256) & 0xFF;
    int lowByte = minutes & 0xFF;
    return [0x10, 0xFF, 0x12, highByte, lowByte];
  }

  /// Get density command
  List<int> getDensityCommand() {
    return [0x10, 0xFF, 0x11];
  }

  /// Set density command
  List<int> setDensityCommand(int density) {
    return [0x10, 0xFF, 0x10, 0x00, density & 0xFF];
  }

  /// Get speed command
  List<int> getSpeedCommand() {
    return [0x10, 0xFF, 0x20, 0xA0];
  }

  /// Set speed command
  List<int> setSpeedCommand(int speed) {
    return [0x10, 0xFF, 0xC0, speed & 0xFF];
  }

  /// Enable printer command
  List<int> getEnablePrinterCommand({int mode = 3}) {
    return [0x10, 0xFF, 0xF1, mode & 0xFF];
  }

  /// Stop print job command - FIXED: Proper PPD1 stop command
  List<int> getStopPrintCommand() {
    return [0x10, 0xFF, 0xF1, 0x45]; // PPD1 specific stop command
  }

  /// Wakeup command
  List<int> getWakeupCommand() {
    return [
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00
    ];
  }

  /// Print line dots command
  List<int> getPrintLineDotsCommand(int dots) {
    return [0x1B, 0x4A, dots & 0xFF];
  }

  /// Print reverse line dots command
  List<int> getPrintReverseLineDotsCommand(int dots) {
    return [0x1F, 0x11, 0x11, dots & 0xFF];
  }

  /// Printer position command
  List<int> getPrinterPositionCommand() {
    return [0x1D, 0x0C];
  }

  /// Set printer width command
  List<int> getSetWidthCommand(int width) {
    int lowByte = width & 0xFF;
    int highByte = (width >> 8) & 0xFF;
    return [0x10, 0xFF, 0x15, lowByte, highByte];
  }

  /// Set heating level command
  List<int> getSetHeatingLevelCommand(int level) {
    return [0x1F, 0x70, 0x01, level & 0xFF];
  }

  /// Set printer mode command
  List<int> getSetPrinterModeCommand(int mode) {
    return [0x10, 0xFF, 0x30, 0x27, mode & 0xFF];
  }

  /// Set paper type command
  List<int> getSetPaperTypeCommand(int type1, int type2) {
    return [0x1F, 0x80, type1 & 0xFF, type2 & 0xFF];
  }

  /// Adjust position auto command
  List<int> getAdjustPositionAutoCommand(int position) {
    return [0x1F, 0x11, position & 0xFF];
  }

  /// Set recovery command
  List<int> getSetRecoveryCommand() {
    return [0x10, 0xFF, 0x04];
  }

  /// Get time format command
  List<int> getTimeFormatCommand() {
    return [0x10, 0xFF, 0xB0];
  }

  /// Set time format command
  List<int> getSetTimeFormatCommand(int format, DateTime dateTime) {
    List<int> timeData = _getTimeFormatData(dateTime);
    List<int> command = [0x10, 0xFF, 0x53, 0x4A, format & 0xFF];
    command.addAll(timeData);
    return command;
  }

  /// Mark print last command - CRITICAL FIX: Based on decompiled AAR source
  List<int> getMarkPrintLastCommand() {
    return [
      0x1B,
      0xBB,
      0xBB
    ]; // [27, 187, 187] from BaseNormalDevice.setMarkPrintLast()
  }

  /// Send custom command
  List<int> getSendCustomCommand(List<int> commandBytes) {
    return List.from(commandBytes);
  }

  /// Complete PPD1 printing sequence - FIXED: Based on decompiled AAR analysis
  List<int> getPPD1CompleteSequence(List<int> bitmapData,
      {int paperWidth = 384, bool isLastPage = true}) {
    List<int> commands = [];

    // 1. enablePrinterLuck() - Enable printer with mode 3
    commands.addAll([0x10, 0xFF, 0xF1, 0x03]);

    // 2. printerWakeupLuck() - Wakeup printer (12 zero bytes)
    commands.addAll([
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00
    ]);

    // 3. sendBitmap() - Format bitmap with proper header from PrinterImageProcessor
    List<int> formattedBitmap = formatBitmapWithHeader(bitmapData, paperWidth);
    commands.addAll(formattedBitmap);

    // 4. printLineDotsLuck(getEndLineDot()) - Calculate based on paper width
    int endLineDots = paperWidth == 384 ? 80 : 120;
    commands.addAll([0x1B, 0x4A, endLineDots & 0xFF]);

    // 5. setMarkPrintLast() - Only on last page (from PPD1.printOnce logic)
    if (isLastPage) {
      commands.addAll([0x1B, 0xBB, 0xBB]); // [27, 187, 187] correct command
    }

    // 6. stopPrintJobLuck() - Final command
    commands.addAll([0x10, 0xFF, 0xF1, 0x45]);

    return commands;
  }

  /// Format bitmap data with proper header - Based on PrinterImageProcessor.getBitmapByteArray()
  List<int> formatBitmapWithHeader(List<int> bitmapData, int paperWidth,
      {bool useCompression = false}) {
    // Calculate dimensions
    int bytesPerLine = (paperWidth + 7) ~/ 8; // Round up division
    int height = bitmapData.length ~/ bytesPerLine;

    if (useCompression) {
      // Use compression header from getBitmapByteArrayCompress
      List<int> header = [
        0x1F, 0x10, // Compression command
        (bytesPerLine >> 8) & 0xFF, bytesPerLine & 0xFF, // width in bytes
        (height >> 8) & 0xFF, height & 0xFF, // height in pixels
        0x00, 0x00, 0x00, 0x00 // Placeholder for compressed size (4 bytes)
      ];

      // For now, return uncompressed but with optimized header
      List<int> result = [];
      result.addAll(header);
      result.addAll(bitmapData);
      return result;
    } else {
      // Normal bitmap header from PrinterImageProcessor: [29, 118, 48, mode, w_low, w_high, h_low, h_high]
      List<int> header = [
        0x1D, 0x76, 0x30, 0x00, // GS v 0 mode (0 = normal bitmap mode)
        bytesPerLine & 0xFF, (bytesPerLine >> 8) & 0xFF, // width in bytes
        height & 0xFF, (height >> 8) & 0xFF // height in pixels
      ];

      // Combine header + bitmap data
      List<int> result = [];
      result.addAll(header);
      result.addAll(bitmapData);

      return result;
    }
  }

  // Helper methods

  /// Convert DateTime to time format data
  List<int> _getTimeFormatData(DateTime dateTime) {
    int year = dateTime.year;
    int yearHigh = (year ~/ 256) & 0xFF;
    int yearLow = year & 0xFF;
    int month = dateTime.month & 0xFF;
    int day = dateTime.day & 0xFF;
    int hour = dateTime.hour & 0xFF;
    int minute = dateTime.minute & 0xFF;
    int second = dateTime.second & 0xFF;

    return [yearHigh, yearLow, month, day, hour, minute, second];
  }
}

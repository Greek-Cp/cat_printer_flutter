// ignore_for_file: library_private_types_in_public_api
///
/// A Flutter library for connecting and printing to Cat Printer via Bluetooth.
/// Ported from Python Cat-Printer with all data and communication protocols.
///
/// Usage:
/// ```dart
/// import 'package:cat_printer_flutter/cat_printer_flutter.dart';
/// import 'package:flutter/material.dart';
///
/// final printerService = CatPrinterService();
/// await printerService.connect(device);
/// 
/// // Print text
/// await printerService.printText('Hello Cat Printer!');
/// 
/// // Print image
/// await printerService.printImage(image);
/// 
/// // Print widget directly
/// await printerService.printWidget(
///   Container(
///     padding: EdgeInsets.all(16),
///     child: Column(
///       children: [
///         Text('Hello from Widget!', style: TextStyle(fontSize: 24)),
///         Icon(Icons.print, size: 48),
///       ],
///     ),
///   ),
/// );
/// ```
library cat_printer_flutter;

// Export all public APIs
export 'services/cat_printer_service.dart';
export 'models/printer_models.dart';
export 'services/printer_commander.dart';

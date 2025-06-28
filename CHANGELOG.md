# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-01-XX

### Added
- Initial release of Cat Printer Flutter library
- Complete port from Python Cat-Printer implementation
- Support for all Cat Printer models (GB01, GB02, GB03, MX05, MX06, MX10, YT01)
- Bluetooth Low Energy communication via flutter_blue_plus
- Text printing with configurable settings
- Image printing with scaling and dithering options
- Flow control for stable communication
- Comprehensive example application
- Full API documentation

### Features
- `CatPrinterService` - Main service class for printer operations
- `PrinterModels` - Utility class for printer model information
- `PrinterConfig` - Configuration class for printer settings
- `PrinterCommander` - Low-level communication protocol implementation
- Automatic device scanning and connection
- Real-time printer status monitoring
- Configurable energy levels, print speed, and quality
- Support for custom image scaling and threshold settings
- Cross-platform support (Android, iOS, macOS, Windows, Linux)

### Dependencies
- flutter_blue_plus: ^1.14.0
- image: ^4.0.17
- permission_handler: ^11.0.1
- file_picker: ^6.1.1
- path_provider: ^2.1.1
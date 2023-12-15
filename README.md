# Bluetooth Printer Plugin for Flutter

This Flutter plugin allows you to interact with Bluetooth printers to perform various printing operations. It uses the BlueThermalPrinterEllib library for communication with Bluetooth printers.

## Features

- Get a list of paired Bluetooth devices
- Connect to a Bluetooth printer
- Print text with customizable size and alignment
- Print images from file or byte array

## Installation

Add the following dependency to your `pubspec.yaml` file:

```yaml
dependencies:
  bluetooth_printer_plugin: ^latest_version
```

Then run:

```bash
flutter pub get
```

## Usage

```dart
import 'package:bluetooth_printer_plugin/bluetooth_printer_plugin.dart';

// Create an instance of the plugin
BluetoothPrinterPlugin bluetoothPrinter = BluetoothPrinterPlugin();

// Get a list of paired Bluetooth devices
List<String> pairedDevices = await bluetoothPrinter.getPairedDevices();

// Connect to a Bluetooth printer
String printerAddress = "00:11:22:33:44:55"; // Replace with the actual Bluetooth address
bool isConnected = await bluetoothPrinter.connectDevice(printerAddress);

// Print text
String textToPrint = "Hello, Bluetooth Printer!";
bool success = await bluetoothPrinter.printText(textToPrint, size: 20, align: 1);

// Print an image from file
String imagePath = "/path/to/your/image.png"; // Replace with the actual image path
success = await bluetoothPrinter.printImage(imagePath);

// Print an image from byte array
List<int> imageBytes = [/* byte array of your image */];
success = await bluetoothPrinter.printImageBytes(imageBytes);
```

Make sure to replace the placeholder values with the actual Bluetooth device address and image path.

## Permissions

Make sure to request the necessary permissions in your AndroidManifest.xml:

```xml
<uses-permission android:name="android.permission.BLUETOOTH" />
<uses-permission android:name="android.permission.BLUETOOTH_ADMIN" />
<uses-permission android:name="android.permission.BLUETOOTH_SCAN" />
<uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
```

Additionally, ensure that you handle runtime permissions appropriately in your Flutter app.

## Note

This plugin assumes that the BlueThermalPrinterEllib library is properly configured and available in your project.

For more details, refer to the official [BlueThermalPrinterEllib repository](https://github.com/elsistemas/BlueThermalPrinterEllib).

## Example

For a complete example of how to use this plugin, please refer to the `example` folder in the repository.

## Issues and Contributions

If you encounter any issues or have suggestions for improvements, feel free to [open an issue](https://github.com/maktubcompany/bluetooth_printer_plugin/issues) or submit a pull request.

Happy Printing! 🖨️✨
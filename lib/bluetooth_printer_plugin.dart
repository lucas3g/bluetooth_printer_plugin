import 'dart:convert';

import 'bluetooth_printer_plugin_platform_interface.dart';

class BluetoothPrinterPlugin {
  Future<List<Map<String, dynamic>>> getPairedDevices() async {
    final json =
        await BluetoothPrinterPluginPlatform.instance.getPairedDevices();

    final devices = List<Map<String, dynamic>>.from(jsonDecode(json));

    return devices;
  }

  Future<bool> connectDevice(String address) async {
    final result =
        await BluetoothPrinterPluginPlatform.instance.connectDevice(address);

    return result;
  }

  Future<bool> printText(String text, int size, int align) async {
    final result = await BluetoothPrinterPluginPlatform.instance
        .printText(text, size, align);

    return result;
  }
}

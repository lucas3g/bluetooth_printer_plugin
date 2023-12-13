import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'bluetooth_printer_plugin_platform_interface.dart';

/// An implementation of [BluetoothPrinterPluginPlatform] that uses method channels.
class MethodChannelBluetoothPrinterPlugin
    extends BluetoothPrinterPluginPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('bluetooth_printer_plugin');

  @override
  Future<String> getPairedDevices() async {
    final devices =
        await methodChannel.invokeMethod<String>('getPairedDevices');

    return devices ?? '';
  }

  @override
  Future<bool> connectDevice(String address) async {
    final result = await methodChannel
        .invokeMethod<bool>('connectDevice', {'address': address});

    return result ?? false;
  }

  @override
  Future<bool> printText(String text, int size, int align) async {
    final result = await methodChannel.invokeMethod<bool>(
        'printText', {'text': text, 'size': size, 'align': align});

    return result ?? false;
  }
}

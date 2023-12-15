import 'dart:ui' as ui;

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
  Future<bool> connectDevice(String address, int widthPaper) async {
    final result = await methodChannel.invokeMethod<bool>(
        'connectDevice', {'address': address, 'widthPaper': widthPaper});

    return result ?? false;
  }

  @override
  Future<bool> printText({
    required String text,
    required int size,
    required int align,
  }) async {
    final result = await methodChannel.invokeMethod<bool>(
        'printText', {'text': text, 'size': size, 'align': align});

    return result ?? false;
  }

  @override
  Future<bool> printImage({required ui.Image image}) async {
    methodChannel.invokeMethod<bool>('printImage', {'image': image});

    return true;
  }

  @override
  Future<bool> printImageBytes(
      {required Uint8List bytes, required int align}) async {
    final result = await methodChannel.invokeMethod<bool>(
        'printImageBytes', {'bytes': bytes, 'align': align});

    return result ?? false;
  }

  @override
  Future<bool> disconnectDevice() async {
    final result = await methodChannel.invokeMethod<bool>('disconnectDevice');

    return result ?? false;
  }
}

import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'bluetooth_printer_plugin_method_channel.dart';

abstract class BluetoothPrinterPluginPlatform extends PlatformInterface {
  /// Constructs a BluetoothPrinterPluginPlatform.
  BluetoothPrinterPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static BluetoothPrinterPluginPlatform _instance =
      MethodChannelBluetoothPrinterPlugin();

  /// The default instance of [BluetoothPrinterPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelBluetoothPrinterPlugin].
  static BluetoothPrinterPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [BluetoothPrinterPluginPlatform] when
  /// they register themselves.
  static set instance(BluetoothPrinterPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String> getPairedDevices();

  Future<bool> connectDevice(String address, int widthPaper);

  Future<bool> disconnectDevice();

  Future<bool> printText({
    required String text,
    required int size,
    required int align,
  });

  Future<bool> printImage({required ui.Image image});

  Future<bool> printImageBytes({required Uint8List bytes, required int align});
}

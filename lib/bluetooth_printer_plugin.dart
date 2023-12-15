import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;

import 'package:bluetooth_printer_plugin/domain/entities/bluetooth_device.dart';
import 'package:bluetooth_printer_plugin/domain/states/bluetooth_states.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'bluetooth_printer_plugin_platform_interface.dart';

class BluetoothPrinterPlugin extends ChangeNotifier {
  late BluetoothStates _state = EmptyStateBluetooth();

  BluetoothStates get state => _state;

  late List<BluetoothDevice> _devices = [];

  List<BluetoothDevice> get devices => _devices;

  void setDevices(List<BluetoothDevice> devices) {
    _devices = devices;
  }

  Future<void> getPairedDevices() async {
    final json =
        await BluetoothPrinterPluginPlatform.instance.getPairedDevices();

    final devicesJson = List<Map<String, dynamic>>.from(jsonDecode(json));

    _devices = devicesJson.map(BluetoothDevice.fromJson).toList();
  }

  Future<bool> disconnectDevice() async {
    bool disconnect = false;
    if (await BluetoothPrinterPluginPlatform.instance.disconnectDevice()) {
      _devices.firstWhere((e) => e.isConnected).setConnected(false);

      disconnect = true;
    }

    notifyListeners();
    return disconnect;
  }

  Future<bool> connectDevice(String address, int widthPaper) async {
    _state = ConnectingBlueooth();

    notifyListeners();

    final result = await BluetoothPrinterPluginPlatform.instance
        .connectDevice(address, widthPaper);

    if (result) {
      devices
          .firstWhere((element) => element.address == address)
          .setConnected(result);
    }

    _state = EmptyStateBluetooth();

    notifyListeners();

    return result;
  }

  Future<bool> printText({
    required String text,
    required int size,
    required int align,
  }) async {
    final result = await BluetoothPrinterPluginPlatform.instance
        .printText(text: text, size: size, align: align);

    return result;
  }

  Future<bool> printImage(String path) async {
    final ByteData data = await rootBundle.load(path);

    final Completer<ui.Image> completer = Completer();

    ui.decodeImageFromList(Uint8List.view(data.buffer), (ui.Image img) {
      completer.complete(img);
    });

    final image = await completer.future;

    final result =
        await BluetoothPrinterPluginPlatform.instance.printImage(image: image);

    return result;
  }

  Future<bool> printImageBytes(Uint8List bytes, int align) async {
    final result = BluetoothPrinterPluginPlatform.instance
        .printImageBytes(bytes: bytes, align: align);

    return result;
  }
}

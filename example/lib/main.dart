import 'dart:async';

import 'package:bluetooth_printer_plugin/bluetooth_printer_plugin.dart';
import 'package:bluetooth_printer_plugin/domain/states/bluetooth_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool connected = false;

  late bool loadingDevices = false;

  final _bluetoothPrinterPlugin = BluetoothPrinterPlugin();

  @override
  void initState() {
    super.initState();

    _bluetoothPrinterPlugin.addListener(() {
      setState(() {});
    });
  }

  Future<void> getPairedDevices() async {
    loadingDevices = true;
    setState(() {});

    await _bluetoothPrinterPlugin.getPairedDevices();

    if (!mounted) return;

    setState(() {
      loadingDevices = false;
    });
  }

  Future<void> connectDevice(String address, int widhPaper) async {
    await _bluetoothPrinterPlugin.connectDevice(address, widhPaper);
  }

  Future<void> disconnectDevice() async {
    await _bluetoothPrinterPlugin.disconnectDevice();
  }

  Future<void> printText(String text, int size, int align) async {
    await _bluetoothPrinterPlugin.printText(
        text: text, size: size, align: align);
  }

  Future<void> printImage(String path) async {
    await _bluetoothPrinterPlugin.printImage(path);
  }

  Future<Uint8List> getImageFromAssets(String path) async {
    ByteData data = await rootBundle.load(path);
    return data.buffer.asUint8List();
  }

  Future<void> printImageBytes(String path, int align) async {
    final bytes = await getImageFromAssets(path);

    _bluetoothPrinterPlugin.printImageBytes(bytes, align);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            loadingDevices
                ? const CircularProgressIndicator()
                : Expanded(
                    child: ListView.builder(
                      itemCount: _bluetoothPrinterPlugin.devices.length,
                      itemBuilder: (context, index) {
                        final printer = _bluetoothPrinterPlugin.devices[index];
                        final state = _bluetoothPrinterPlugin.state;

                        return ListTile(
                          leading: state is ConnectingBlueooth
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : null,
                          onTap: () async {
                            if (!printer.isConnected) {
                              await connectDevice(printer.address, 80);

                              return;
                            }

                            await disconnectDevice();
                          },
                          title: Text(printer.name),
                          subtitle: Text(
                            printer.isConnected ? 'Connected' : 'Disconnected',
                          ),
                        );
                      },
                    ),
                  ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _bluetoothPrinterPlugin.devices
                      .where((e) => e.isConnected)
                      .isNotEmpty
                  ? () {
                      printText('Print Test!!', 1, 0);
                    }
                  : null,
              child: const Text('Print Test'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _bluetoothPrinterPlugin.devices
                      .where((e) => e.isConnected)
                      .isNotEmpty
                  ? () => printImageBytes('assets/images/qr.png', 1)
                  : null,
              child: const Text('Print Image'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                getPairedDevices();
              },
              child: const Text('Search Devices'),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

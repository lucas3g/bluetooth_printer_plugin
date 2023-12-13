import 'dart:async';

import 'package:bluetooth_printer_plugin/bluetooth_printer_plugin.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Map<String, dynamic>> _devices = [];
  late bool connected = false;

  final _bluetoothPrinterPlugin = BluetoothPrinterPlugin();

  @override
  void initState() {
    super.initState();

    getPairedDevices();
  }

  Future<void> getPairedDevices() async {
    late List<Map<String, dynamic>> devices;

    devices = await _bluetoothPrinterPlugin.getPairedDevices();

    if (!mounted) return;

    setState(() {
      _devices = devices;
    });
  }

  Future<void> connectDevice(String address) async {
    connected = await _bluetoothPrinterPlugin.connectDevice(address);

    setState(() {});
  }

  Future<void> printText(String text, int size, int align) async {
    await _bluetoothPrinterPlugin.printText(text, size, align);
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
            Expanded(
              child: ListView.builder(
                itemCount: _devices.length,
                itemBuilder: (context, index) {
                  final printer = _devices[index];

                  return ListTile(
                    onTap: () async => await connectDevice(printer['address']),
                    title: Text(printer['name']),
                    subtitle: Text(connected ? 'Conectada' : 'Desconectada'),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: connected
                  ? () {
                      printText('Impressao de teste!!!', 1, 1);
                    }
                  : null,
              child: const Text('Imprimir'),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

package com.maktubcompany.bluetooth_printer_plugin

import com.elsistemas.bluetoothprinterellib.BlueThermalPrinterPlugin

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

import android.content.Context


/** BluetoothPrinterPlugin */
class BluetoothPrinterPlugin: FlutterPlugin, MethodCallHandler {
  private lateinit var context: Context

  private lateinit var channel : MethodChannel

  private lateinit var blue: BlueThermalPrinterPlugin

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    context = flutterPluginBinding.applicationContext;

    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "bluetooth_printer_plugin")
    channel.setMethodCallHandler(this)

    blue = BlueThermalPrinterPlugin(context);
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    if (call.method == "getPairedDevices") {
      result.success(blue.pairedDevices)
    }

    if (call.method == "connectDevice") {
      val args = call.arguments as Map<String, *>
      val address = args["address"] as String

      result.success(blue.connect(address))
    }

    if (call.method == "printText") {
      val args = call.arguments as Map<String, *>
      val text = args["text"] as String
      val size = args["size"] as Int
      val align = args["align"] as Int

      result.success(blue.printCustom(text, size, align))
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}

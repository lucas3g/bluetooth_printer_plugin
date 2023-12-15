package com.maktubcompany.bluetooth_printer_plugin

import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.os.Build
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import com.elsistemas.bluetoothprinterellib.BlueThermalPrinterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.RequestPermissionsResultListener


/** BluetoothPrinterPlugin */
class BluetoothPrinterPlugin: FlutterPlugin, MethodCallHandler, ActivityAware, RequestPermissionsResultListener {
  private lateinit var context: Context

  private lateinit var channel : MethodChannel

  private lateinit var blue: BlueThermalPrinterPlugin

  private  var activity: Activity? = null

  private  var pluginBinding: FlutterPluginBinding? = null

  private  var activityBinding: ActivityPluginBinding? = null

  private val initializationLock = Any()

  private var hasBluetoothPermission = false

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    pluginBinding = flutterPluginBinding;

    context = flutterPluginBinding.applicationContext;

    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "bluetooth_printer_plugin")
    channel.setMethodCallHandler(this)

    blue = BlueThermalPrinterPlugin(context);
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    if (hasBluetoothPermission) {
      when (call.method) {
        "getPairedDevices" -> {
          if (!blue.bluetoothActivated()){
            blue.enableBluetooth(activity)
          }

          result.success(blue.pairedDevices)
        }
        "connectDevice" -> {
          val args = call.arguments as Map<String, *>
          val address = args["address"] as String
          val widthPaper = args["widthPaper"] as Int

          result.success(blue.connect(address, widthPaper))
        }
        "disconnectDevice" -> {
          result.success(blue.disconnect())
        }
        "printText" -> {
          val args = call.arguments as Map<String, *>
          val text = args["text"] as String
          val size = args["size"] as Int
          val align = args["align"] as Int

          result.success(blue.printText(text, size, align))
        }
        "printImage" -> {
          val args = call.arguments as Map<String, *>
          val image = args["image"] as Bitmap

          result.success(blue.printImage(image))
        }
        "printImageBytes" -> {
          val args = call.arguments as Map<String, *>
          val bytes = args["bytes"] as ByteArray
          val align = args["align"] as Int

          result.success(blue.printImageBytes(bytes, align))
        }
        else -> result.notImplemented()
      }
    } else {
      checkAndRequestBluetoothPermissions()
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    pluginBinding = null;
  }

  private fun checkAndRequestBluetoothPermissions(){
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
      if (ContextCompat.checkSelfPermission(
          activity!!,
          Manifest.permission.BLUETOOTH_SCAN
        ) != PackageManager.PERMISSION_GRANTED ||
        ContextCompat.checkSelfPermission(
          activity!!,
          Manifest.permission.BLUETOOTH_CONNECT
        ) != PackageManager.PERMISSION_GRANTED
      ) {
        ActivityCompat.requestPermissions(
          activity!!,
          arrayOf(
            Manifest.permission.BLUETOOTH_SCAN,
            Manifest.permission.BLUETOOTH_CONNECT
          ),
          1
        )
      } else {
        hasBluetoothPermission = true
      }
    }
  }

  override fun onRequestPermissionsResult(
    requestCode: Int,
    permissions: Array<out String>,
    grantResults: IntArray
  ): Boolean {
    if (requestCode == 1) {
      hasBluetoothPermission = grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED
      return true
    }
    return false
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activityBinding = binding;

    setup(activityBinding!!.activity)
  }

  override fun onDetachedFromActivityForConfigChanges() {
    onDetachedFromActivity()
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    onAttachedToActivity(binding)
  }

  override fun onDetachedFromActivity() {
    detach()
  }

  private fun setup(
    activity: Activity,
  ) {
    synchronized(initializationLock) {
      this.activity = activity

      checkAndRequestBluetoothPermissions()
    }
  }

  private fun detach() {
    activityBinding!!.removeRequestPermissionsResultListener(this)
    activityBinding = null
    channel.setMethodCallHandler(null)
  }
}

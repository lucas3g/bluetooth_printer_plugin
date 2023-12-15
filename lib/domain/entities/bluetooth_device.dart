class BluetoothDevice {
  final String name;
  final String address;
  final int type;
  bool isConnected = false;

  void setConnected(bool connected) {
    isConnected = connected;
  }

  BluetoothDevice({
    required this.name,
    required this.address,
    required this.type,
  });

  static BluetoothDevice fromJson(Map<String, dynamic> json) {
    return BluetoothDevice(
      name: json['name'],
      address: json['address'],
      type: json['type'],
    );
  }
}

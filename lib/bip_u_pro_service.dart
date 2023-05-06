import 'dart:async';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class AmazfitBipUProService {
  
  final _ble = FlutterReactiveBle();
  Stream<DiscoveredDevice> get scanStream => _ble.scanForDevices(
        withServices: [], 
        // Adicione aqui os UUIDs dos serviços que você deseja escanear, se necessário.
        scanMode: ScanMode.balanced,
      );

  StreamSubscription<void> connectToDevice(String deviceId) {
    return _ble.connectToDevice(
      id: deviceId,
      connectionTimeout: const Duration(seconds: 5),
    )
      .listen((connectionState) {
      // Gerencie o estado da conexão aqui, se necessário.
    });
  }

  discoverServices(String deviceId) async {
     var servicos = await _ble.discoverServices(deviceId);
     print("servicos ======== ${servicos}");
  }

  Future<int> readHeartRate(
    String deviceId, QualifiedCharacteristic characteristic) async {
    final heartRateData = await _ble.readCharacteristic(characteristic);
    return heartRateData[1]; // Assume que o valor do BPM está na posição 1 da lista.
  }
}

import 'dart:async';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class AmazfitBipUProService {

 //fornece os métodos para que seja possível realizar a leitura
  final _ble = FlutterReactiveBle();

 //estabelece uma conexão com o dispositivo
  StreamSubscription<void> connectToDevice(String deviceId) {
    return _ble.connectToDevice(
      id: deviceId,
      connectionTimeout: const Duration(seconds: 5),
    )
      .listen((connectionState) {
      // Gerencie o estado da conexão aqui, se necessário.
    });
  }

  //retorna uma lista de dispositivos descobertos
  Stream<DiscoveredDevice> get scanStream => _ble.scanForDevices(
        withServices: [],
        scanMode: ScanMode.balanced,
      );

  //funçao responsável por realizar a leitura
  Future<int> readCharacteristic(
      String deviceId, QualifiedCharacteristic characteristic) async {
    final data = await _ble.readCharacteristic(characteristic);
    return data[1]; // Assume que o valor do BPM está na posição 1 da lista.
  }
}
/*
  discoverServices(String deviceId) async {
     var servicos = await _ble.discoverServices(deviceId);
     print("servicos ======== ${servicos}");
  }
*/
//}

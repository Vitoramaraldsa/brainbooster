import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'bip_u_pro_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _amazfitService = AmazfitBipUProService();
  DiscoveredDevice? _device;
  int? _heartRate;

  String? serviceIdstring;
  String? characteristicString;
  int counter = 0;

  List<String> heartRateCharacteristics = [
    "00002a39-0000-1000-8000-00805f9b34fb",
    ];

  @override
  void initState() {
    super.initState();
    //escanear os dispositivos
    _amazfitService.scanStream.listen((device) {
      if (serviceIdstring != null && characteristicString != null) {
        if (device.name == 'Amazfit Bip U Pro') {
          setState(() {
            _device = device;
          });
          _amazfitService.discoverServices(device.id);
          final connectionSubscription =
              _amazfitService.connectToDevice(device.id);
          final heartRateCharacteristic = QualifiedCharacteristic(
              serviceId: Uuid.parse(serviceIdstring!),
              characteristicId: Uuid.parse(characteristicString!),
              deviceId: device.id);
          _amazfitService
              .readHeartRate(device.id, heartRateCharacteristic)
              .then((heartRate) {
            setState(() {
              _heartRate = heartRate;
            });
          });
          // Cancele a conexão quando não for mais necessária.
          connectionSubscription.cancel();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Amazfit Bip U Pro Data')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    characteristicString = heartRateCharacteristics[counter];
                    counter++;
                  });
                },
                child: const Text("Testar")),
            const SizedBox(height: 80),
            Text('Device: ${_device?.name}'),
            const SizedBox(height: 10),
            Text('RESULTADO DO UUID: ${_heartRate != null ? _heartRate.toString() : 'N/A'}'),
            // Adicione aqui os widgets para exibir outras informações, como notificações recebidas e nível de oxigênio do sangue.
          ],
        ),
      ),
    );
  }
}

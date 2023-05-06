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
  //instanciar o serviço
  final _amazfitService = AmazfitBipUProService();
  //possivel dispositivo conectado
  DiscoveredDevice? _device;
  //valor capturado na caracteristica e servico
  String? _valueCharacteristic;

  //uuid servico e caracteristica
  /*
  String? serviceIdstring;
  String? characteristicString;
  */

  var unknownService = "0000fee0-0000-1000-8000-00805f9b34fb";
  var unknownCharacteristics = [
    "00002a2b-OOOO-1000-8000-00805f9b34fb",
    "00002a04-0000-1000-8000-00805f9b34fb",
    //----------------------------------------
    //resultado foi 31
    "00000006-0000-3512-2118-0009af100700",
    //----------------------------------------
    "00000007-0000-3512-2118-ooogaf100700"
  ];

  var counter = 0;

  @override
  void initState() {
    super.initState();
    //escanear os dispositivos ao iniciar a aplicacao
    _amazfitService.scanStream.listen((device){
      //ver se o dispositivo é a amazfit
      if (device.name == 'Amazfit Bip U Pro') {
        //instanciar o dispositivo
        setState(
          () {
            _device = device;
          },
        );
        //realizar a conexão
        final connectionSubscription = _amazfitService.connectToDevice(device.id);
        try {
          //capturar o valor da caracteristica + service
          final characteristicCapture = QualifiedCharacteristic(
            serviceId: Uuid.parse(unknownService),
            characteristicId: Uuid.parse(unknownCharacteristics[counter]),
            deviceId: device.id,
          );
          //ler a caracteristica qualificada
          _amazfitService
              .readCharacteristic(device.id, characteristicCapture)
              .then((value) {
               setState(() {
                 _valueCharacteristic = value.toString();
               });
          });
          // Cancele a conexão quando não for mais necessária.
          connectionSubscription.cancel();
        } catch (error) {
          print(error.toString());
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
                    counter++;
                  });
                },
                child: const Text("Testar")),
            const SizedBox(height: 80),
            Text('Device: ${_device?.name}'),
            const SizedBox(height: 10),
            Text('RESULTADO DO UUID: $_valueCharacteristic'),
            // Adicione aqui os widgets para exibir outras informações, como notificações recebidas e nível de oxigênio do sangue.
          ],
        ),
      ),
    );
  }
}

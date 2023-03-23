import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
bool bluetoothIsAvaiblade = false;
bool bluetoothIsOn = false;


class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        const CardPrincipal(),
        Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: ElevatedButton(
                onPressed: ScanBluetooth,
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 53, 91, 216)),
                child: const Text("Parear com meu dispositivo"),
              ),
            ))
      ],
    ));
  }


  void ScanBluetooth() async {
    //verificar se o device está conectado
    var devices = await flutterBlue.connectedDevices;
    BluetoothDevice? deviceConnected;
    for (BluetoothDevice device in devices){
      if(device.name != ""){
        deviceConnected = device;
        break;
      }
    }
    if(deviceConnected != null){
      /*List<BluetoothService> services = await deviceConnected.discoverServices();
      services.forEach((service) async{ 
         List<BluetoothCharacteristic> characteristics = await service.characteristics;
         print(characteristics.);
      });*/

      List<BluetoothService> services = await deviceConnected.discoverServices();
      for (BluetoothService service in services) {
      /*List<BluetoothCharacteristic> characteristics = service.characteristics;
       print(characteristics);*/
       print(service.includedServices);
      }
    }
    
  }
}

class CardPrincipal extends StatelessWidget {
  const CardPrincipal({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: MediaQuery.of(context).size.height / 1.05,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 70, 132, 247),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:gatt/gatt.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
BluetoothCharacteristic? characteristic;
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
                onPressed: scanBluetooth,
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 53, 91, 216)),
                child: const Text("Parear com meu dispositivo"),
              ),
            ))
      ],
    ));
  }


  void scanBluetooth() async {
  // Procurar dispositivos Bluetooth conectados
  List<BluetoothDevice> connectedDevices = await flutterBlue.connectedDevices;
  // Verificar se o dispositivo desejado está conectado
  for (BluetoothDevice device in connectedDevices) {
  //verficar se é a amazfit 
  if (device.name.trim() == "Amazfit Bip U Pro") {
    if (device != null) {
    //desconectar
     await device.disconnect();
    //conectar aos serviços gatt
     await device.connect(autoConnect: true, timeout: const Duration(seconds: 1));
    List<BluetoothService> services = await device.discoverServices();
    //descobrir os serviços gatt oferecidos pela pulseira
    for (BluetoothService service in services) { 
       for (BluetoothCharacteristic characteristic in service.characteristics) {
        print("-------------------------------------");
          print(characteristic.deviceId);
          print(characteristic.descriptors);
          print(characteristic.uuid);
          print(characteristic.serviceUuid);
          print(characteristic.uuid);
          print(GattId(0, "vbvbv00002a4d-0000-1000-8000-00805f9b34fb"));
          
          
      }
     }
    } else {
    // O dispositivo não está conectado
    print("O dispositivo não está conectado.");
    }
    break;
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


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wear_plus/wear_plus.dart';
// import 'models/counter_model.dart';
import 'models/patient_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Hacemos que la app pueda utilizar los Providers necesarios
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider(create: (_) => CounterModel()),
        ChangeNotifierProvider(create: (_) => PatientModel(service: MockPacientService())),
      ],
      child: MaterialApp(
        title: 'Flutter Wear & Mobile Example',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtenemos el ancho de la pantalla para determinar si es móvil o smartwatch
    double screenWidth = MediaQuery.of(context).size.width;

    // Si el ancho de la pantalla es menor a 300px, es un smartwatch
    if (screenWidth < 300) {
      return const WearablePage();
    } else {
      return const MobilePage();
    }
  }
}

// Widget para mostrar la información de un paciente
class PatientViewer extends StatelessWidget {
  // Definimos un atributo para modificar el tamaño del texto
  final double textSize;

  const PatientViewer({super.key, required this.textSize});

  @override
  Widget build(BuildContext context) {
    // Creamos un Consumer de PatientModel ya que vamos a leer sus datos
    return Consumer<PatientModel>(
      builder: (context, patientModel, child) {
        return patientModel.loading
            // Si el modelo está cargando, ponemos el spinner
            ? const CircularProgressIndicator()
            : patientModel.patient == null
                // Si no hay paciente mostramos la información correspondiente
                ? Text(patientModel.info, textAlign: TextAlign.center)
                // Información del paciente
                : Column(
                    children: [
                      Text(
                        'ID: ${patientModel.patient?.id}',
                        style: TextStyle(fontSize: textSize),
                      ),
                      Text(
                        key: const Key('patientViewerName'),
                        'Name: ${patientModel.patient?.name}',
                        style: TextStyle(fontSize: textSize),
                      ),
                      Text(
                        'Surname: ${patientModel.patient?.surname}',
                        style: TextStyle(fontSize: textSize),
                      ),
                      Text(
                        'Code: ${patientModel.patient?.code}',
                        style: TextStyle(fontSize: textSize),
                      ),
                    ],
                  );
      },
    );
  }
}

// Widget padre para el smartwatch
class WearablePage extends StatelessWidget {
  const WearablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WatchShape(
      builder: (BuildContext context, WearShape shape, Widget? child) {
        // AmbientMode nos permite escoger entre dos pantallas, una de "ambiente" cuando el smartwatch está en resposo y otra
        //    para cuando está activo, en este ejemplo devolvemos siempre la misma, como si siempre estuviera activo
        return AmbientMode(
          builder: (context, mode, child) {
            return const ActiveWatchFace();
            // Para alternar entre pantallas ambiente y activa, usaríamos la siguiente línea
            // return mode == Mode.active ? ActiveWatchFace() : AmbientWatchFace();
          },
        );
      },
    );
  }
}

// Pantalla para el smartwatch
class ActiveWatchFace extends StatelessWidget {
  const ActiveWatchFace({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Info Paciente',
                style: TextStyle(fontSize: 18),
              ),
              // Utilizamos el widget que definimos antes para visualizar la información del paciente
              const PatientViewer(textSize: 14),
              const SizedBox(height: 10),
              // Creamos un botón que llame al método del modelo para obtener un paciente aleatorio
              ElevatedButton(
                onPressed: () {
                  context.read<PatientModel>().getRandomPatient();
                },
                child: const Icon(Icons.change_circle),
              ),
            ],
          ),
        ),
      );
}

// Pantalla para el móvil (en este caso no hay distinción entre activo/ambiente)
class MobilePage extends StatelessWidget {
  const MobilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Info Paciente'),
        ),
        body: const Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              // Utilizamos el widget que definimos antes para visualizar la información del paciente
              children: [PatientViewer(textSize: 20)]),
        ),
        // Creamos un botón que llame al método del modelo para obtener un paciente aleatorio
        floatingActionButton: FloatingActionButton(
            onPressed: () => context.read<PatientModel>().getRandomPatient(),
            child: const Icon(Icons.change_circle)));
  }
}

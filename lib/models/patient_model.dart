import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Esta es la dirección de nuestro ordenador para los emuladores
const source = 'http://10.0.2.2:8000';

// Servicio que se conecta con la BD
class PatientService {
  // Método para generar un paciente aleatorio de la lista de pacientes
  Future<Patient> getRandomPatient() async {
    // Hacemos la petición al servidor; si en 3s no obtenemos respuesta lanzamos el error
    final response = await http.get(Uri.parse('$source/patients')).timeout(
        const Duration(seconds: 3),
        onTimeout: () => http.Response('Error', 408));

    // Si la respuesta es un 200 OK, creamos el paciente y lo devolvemos
    if (response.statusCode == 200) {
      return Patient.fromJson(jsonDecode(response.body) as List<dynamic>);
      // En otro caso, lanzamos una excepción
    } else {
      throw Exception();
    }
  }
}

// Servicio que simula el servicio real
class MockPacientService extends PatientService {
  @override
  // Método para devolver un paciente de test
  Future<Patient> getRandomPatient() {
    return Future(() => const Patient(id: 1, name: 'Tester', surname: 'McTesting', code: '314-42-2001'));
  }
}

// Modelo para el paciente, parte del patrón Provider
class PatientModel with ChangeNotifier {
  // Atributos para la actuar en función de lo que se esté haciendo
  bool _loading = false;
  Patient? _patient;
  String _info = 'Haga click para obtener un paciente';

  Patient? get patient => _patient;
  String get info => _info;
  bool get loading => _loading;

  // Gestión del servicio del modelo
  late PatientService service;

  PatientModel({service}) {
    this.service = service ?? PatientService();
  }

  // Método del modelo que se llama desde los botones de la vista
  Future<void> getRandomPatient() async {
    // Establecemos que está cargando y se avisa a los oyentes
    _loading = true;
    notifyListeners();
    // Hacemos la llamda al servicio
    try {
      _patient = await service.getRandomPatient();
      // Gestionamos los posibles errores
    } catch (e) {
      _patient = null;
      _info = 'Error al cargar paciente';
      // Avisamos a los oyentes al acabar la operación
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}

// Clase para representar objetos de tipo paciente
class Patient {
  // Atributos
  final int id;
  final String name;
  final String surname;
  final String code;

  // Constructor
  const Patient({
    required this.id,
    required this.name,
    required this.surname,
    required this.code,
  });

  // Método para generar un objeto Patient a partir de la lista de pacientes
  factory Patient.fromJson(List<dynamic> jsonList) {
    final random = Random();
    final json = jsonList[random.nextInt(jsonList.length)];
    return switch (json) {
      {
        'id': int id,
        'name': String name,
        'surname': String surname,
        'code': String code,
      } =>
        Patient(
          id: id,
          name: name,
          surname: surname,
          code: code,
        ),
      _ => throw const FormatException('Failed to load patient.'),
    };
  }
}

// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ipm_test/main.dart';
import 'package:ipm_test/models/patient_model.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('Test PatientViewer displays patient data correctly',
      (WidgetTester tester) async {
    // Creamos una instancia de PatientModel
    final patientModel = PatientModel();

    // Inicializamos la aplicación con el PatientModel en el Provider
    await tester.pumpWidget(
      ChangeNotifierProvider<PatientModel>.value(
        value: patientModel,
        child: const MaterialApp(
          home: Scaffold(body: PatientViewer(textSize: 16)),
        ),
      ),
    );

    // Verificamos que se muestra el mensaje inicial
    expect(find.text('Haga click para obtener un paciente'), findsOneWidget);
  });
}

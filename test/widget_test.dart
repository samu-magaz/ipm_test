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
    final patientModel = PatientModel(service: MockPacientService());

    // Construimos el widget bajo prueba
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => patientModel),
        ],
        child: const MaterialApp(
          home: MobilePage(),
        ),
      ),
    );

    // Verificamos que inicialmente no hay un paciente (esto depende de tu lógica inicial)
    expect(find.textContaining('ID:'), findsNothing);

    // Simulamos un clic en el botón flotante
    final floatingActionButton = find.byType(FloatingActionButton);
    expect(floatingActionButton, findsOneWidget);

    await tester.tap(floatingActionButton);
    await tester.pump(const Duration(seconds: 5)); // Redibuja la UI después del cambio, esperando más tiempo que la petición

    // Verificamos que ahora se muestra información del paciente, y que tiene nombre 'Tester'
    expect(find.byKey(const Key('patientViewerName')), findsOneWidget);
    expect(find.textContaining('Tester'), findsOneWidget);
  });
}

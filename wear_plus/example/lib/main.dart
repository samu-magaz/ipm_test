import 'package:flutter/material.dart';
import 'package:wear_plus/wear_plus.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: WatchShape(
            builder: (context, shape, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Shape: ${shape == WearShape.round ? 'round' : 'square'}',
                  ),
                  child!,
                ],
              );
            },
            child: AmbientMode(
              builder: (context, mode, child) {
                return Text(
                  'Mode: ${mode == WearMode.active ? 'Active' : 'Ambient'}',
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

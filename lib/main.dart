import 'package:flutter/material.dart';
import 'package:projeto_exercicio/pages/ponto_remoto.page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ponto Remoto',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ListaPontoRemotoPage(),
    );
  }
}

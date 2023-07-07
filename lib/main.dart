import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:presensi/screens/splash_screen.dart';
import 'package:presensi/services/absen_services.dart';

void setupLocator() {
  GetIt.I.registerLazySingleton(() => AbsenService());
}

void main() {
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PRESENSI',
      home: SplashScreen(),
    );
  }
}

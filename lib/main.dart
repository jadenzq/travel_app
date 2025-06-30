import 'package:flutter/material.dart';
import 'package:travel_app/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// editing here
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: App(),
  ));
}



import 'package:battle_words/src/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //load environment variables
  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}

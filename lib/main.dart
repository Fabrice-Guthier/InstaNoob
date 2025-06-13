import 'package:flutter/material.dart';
import 'package:likeit/likeit_app.dart';
import 'package:likeit/providers/app_state.dart';
import 'package:provider/provider.dart';

void main() {
  // On utilise Provider pour que l'état global soit accessible partout dans l'app.
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: const MonApp(),
    ),
  );
}



import 'package:flutter/material.dart';
import 'package:likeit/providers/app_state.dart';
import 'package:likeit/screens/ecran_detail.dart';
import 'package:likeit/screens/ecran_favoris.dart';
import 'package:likeit/screens/ecran_master.dart';
import 'package:provider/provider.dart';

class MonApp extends StatelessWidget {
  const MonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        return MaterialApp(
          title: 'Insta-Débutant',
          theme: ThemeData.light(
            useMaterial3: false,
          ),
          darkTheme: ThemeData.dark(
            useMaterial3: false,
          ),
          themeMode: appState.themeMode,
          debugShowCheckedModeBanner: false,

          initialRoute: '/',
          routes: {
            '/': (context) => const EcranMaster(),
            '/details': (context) => const EcranDetail(),
            '/favoris': (context) => const EcranFavoris(),
          },
        );
      },
    );
  }
}

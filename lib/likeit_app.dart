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
    // On écoute le provider pour mettre à jour le thème de toute l'application.
    return Consumer<AppState>(
      builder: (context, appState, child) {
        return MaterialApp(
          title: 'Insta-Débutant',
          theme: ThemeData.light(
            useMaterial3: false,
          ), // Design simple et basique
          darkTheme: ThemeData.dark(
            useMaterial3: false,
          ), // Pas de Material 3 pour garder un look "old school"
          themeMode: appState.themeMode,
          debugShowCheckedModeBanner: false,

          // Déclaration des routes pour la navigation (le fameux "deep linking" de base)
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

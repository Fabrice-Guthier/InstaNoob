import 'package:flutter/material.dart';
import 'package:likeit/providers/app_state.dart';
import 'package:likeit/screens/ecran_master.dart';
import 'package:provider/provider.dart';

class EcranFavoris extends StatelessWidget {
  const EcranFavoris({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mes Favoris')),
      // On écoute la liste des favoris du provider
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          if (appState.photosFavorites.isEmpty) {
            return const Center(
              child: Text('Aucune photo en favori pour le moment.'),
            );
          }
          // On réutilise le widget de la liste
          return ListePhotos(photos: appState.photosFavorites);
        },
      ),
    );
  }
}

// Importe la bibliothèque Material de Flutter pour avoir accès aux widgets de base (boutons, layout, etc.)
import 'package:flutter/material.dart';
// Importe le widget principal de ton application, la racine de ton interface.
import 'package:likeit/likeit_app.dart';
// Pense à elle comme le "GameManager" qui contient le score, la vie du joueur, l'inventaire...
import 'package:likeit/providers/app_state.dart';
// Importe la bibliothèque 'provider', un outil puissant pour la gestion d'état.
// C'est le conteneur d'injection de dépendances (Dependency Injection).
import 'package:provider/provider.dart';

// La fonction 'main', c'est le point d'entrée du programme. L'OS lance l'app par ici.
void main() {
  // `runApp` est la fonction qui prend un Widget et le dessine à l'écran.
  runApp(
    // `ChangeNotifierProvider` est un widget spécial qui va "fournir" une instance d'un objet
    // à tous les widgets qui se trouvent en dessous de lui dans l'arborescence.
    ChangeNotifierProvider(
      // La propriété `create` est une fonction qui fabrique l'objet à partager.
      // Ici, on crée une seule et unique instance de `AppState`. C'est un Singleton pour ton scope.
      create: (context) => AppState(),

      // La propriété `child` est le widget (et tous ses enfants) qui aura accès à `AppState`.
      // Ici, c'est toute ton application, `MonApp`.
      child: const MonApp(),
    ),
  );
}
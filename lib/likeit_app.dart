// Imports des bibliothèques nécessaires.
import 'package:flutter/material.dart';
import 'package:likeit/providers/app_state.dart'; // Notre "GameManager"
import 'package:likeit/screens/ecran_detail.dart'; // L'écran de détail
import 'package:likeit/screens/ecran_favoris.dart'; // L'écran des favoris
import 'package:likeit/screens/ecran_master.dart'; // L'écran principal (la liste)
import 'package:provider/provider.dart';

// 'MonApp' est le widget racine de l'application. C'est la coque, le châssis.
// Il ne gère pas d'état lui-même (StatelessWidget), il se contente de réagir aux changements venus d'ailleurs.
class MonApp extends StatelessWidget {
  const MonApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Ici, on utilise un 'Consumer' de Provider. C'est un widget qui "écoute" les changements
    // sur un objet spécifique, ici notre 'AppState'.
    return Consumer<AppState>(
      // Le 'builder' est une fonction qui va se redessiner *automatiquement*
      // chaque fois que 'appState.notifyListeners()' est appelé.
      // Il nous donne accès à l'instance de 'appState' pour qu'on puisse utiliser ses données.
      builder: (context, appState, child) {
        // 'MaterialApp' est le widget qui configure tout le style global de l'app,
        // la navigation, les thèmes, etc. C'est le moteur de rendu principal.
        return MaterialApp(
          title: 'Insta-NooB', // Le nom de l'app pour l'OS.

          // Configuration du thème clair.
          theme: ThemeData.light(
            useMaterial3: true,
          ),
          // Configuration du thème sombre.
          darkTheme: ThemeData.dark(
            useMaterial3: true,
          ),
          // LA LIGNE MAGIQUE : Le thème utilisé (light, dark, ou système)
          // est directement lu depuis notre 'appState'. Si on change cette valeur
          // dans l'état, l'app entière changera de thème instantanément.
          themeMode: appState.themeMode,
          
          // On cache la bannière "Debug" en haut à droite.
          debugShowCheckedModeBanner: false,

          // Définition du système de navigation de l'app.
          // En ASP.NET Core, ce serait l'équivalent de ton `app.UseRouting()` et `app.MapControllerRoute()`.

          initialRoute: '/', // La route de départ, notre "spawn point".
          routes: {
            // On définit toutes les "destinations" possibles (les écrans).
            // C'est notre système de portails de téléportation.
            '/': (context) => const EcranMaster(),      // L'URL "/" mène à l'écran principal.
            '/details': (context) => const EcranDetail(), // L'URL "/details" mène à l'écran de détail.
            '/favoris': (context) => const EcranFavoris(), // L'URL "/favoris" mène à l'écran des favoris.
          },
        );
      },
    );
  }
}

// Ce fichier, MonApp.dart, est le chef d'orchestre de l'interface de l'application. Il ne fait pas grand-chose lui-même, mais il dit à tout le monde comment se comporter.

// Le Grand Œil (Consumer<AppState>)
// Son rôle principal est de surveiller en permanence le "cerveau" de l'app (AppState). Dès que le cerveau envoie un signal (en appelant notifyListeners()), le Consumer se réveille et met à jour l'interface.

// Le Switch Jour/Nuit (themeMode)
// L'exemple le plus parlant ici est la gestion du thème. La ligne themeMode: appState.themeMode est la clé. Elle connecte directement l'apparence de l'application (claire ou sombre) à une variable dans AppState. Si une autre partie du code (par exemple, un bouton dans les paramètres) modifie cette variable, l'application entière bascule de thème automatiquement. C'est le pouvoir de la gestion d'état centralisée.

// Le GPS de l'App (routes)
// La section routes définit la carte de ton application. C'est un annuaire qui dit : "Si quelqu'un veut aller à l'adresse '/', envoie-le à EcranMaster. S'il demande '/favoris', téléporte-le à EcranFavoris". Cela permet de naviguer entre les écrans de manière simple et organisée, en utilisant des noms de routes plutôt que de manipuler directement les classes des écrans.

// En résumé, ce code met en place une application réactive où l'interface (thème, etc.) est pilotée par un état central et où la navigation entre les écrans est clairement définie. C'est une base saine et standard pour construire une application Flutter.
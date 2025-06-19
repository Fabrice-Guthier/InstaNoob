import 'package:flutter/material.dart';
import 'package:likeit/models/photo.dart';
import 'package:shared_preferences/shared_preferences.dart';

// La classe AppState hérite de `ChangeNotifier`.
// C'est ce qui lui donne le super-pouvoir `notifyListeners()`.
// C'est le pattern Observer : cet objet peut avoir des "observateurs" et les notifier des changements.
// En C#, c'est très similaire à une classe qui implémente l'interface `INotifyPropertyChanged`.
class AppState extends ChangeNotifier {
  // -- Déclaration des États (les variables de notre jeu) --

  // Le `_` au début du nom rend la variable privée au fichier. C'est l'encapsulation.
  // C'est la vraie liste où sont stockées les photos favorites.
  final List<Photo> _photosFavorites = [];
  // Getter public pour que les autres classes puissent LIRE la liste, mais pas la modifier directement.
  // C'est un accès en lecture seule, une excellente pratique.
  List<Photo> get photosFavorites => _photosFavorites;

  // État pour le thème (Clair / Sombre)
  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;

  // État pour le type d'affichage (Liste / Grille)
  bool _isGridView = false;
  bool get isGridView => _isGridView;

  // -- Méthodes pour Modifier l'État (les actions du joueur) --

  // Méthode pour basculer le thème
  void toggleTheme() {
    // Si le thème est clair, on passe en sombre, sinon on passe en clair.
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    // LA LIGNE LA PLUS IMPORTANTE : On envoie un signal à tous les widgets qui écoutent !
    // "Hey tout le monde, le thème a changé, mettez-vous à jour !".
    notifyListeners();
  }

  // Méthode pour basculer la vue
  void toggleView() {
    _isGridView = !_isGridView; // On inverse simplement la valeur du booléen.
    notifyListeners(); // On notifie les widgets du changement.
  }

static const String _keyFavoris =
      'favoris_photos_ids'; // Clé pour shared_preferences
  Set<String> _favoris = {}; // Ensemble des IDs des photos favorites

  Set<String> get favoris => _favoris;

  AppState() {
    _loadFavoris(); // Charge les favoris au démarrage
  }

  // Charge les favoris depuis shared_preferences
  Future<void> _loadFavoris() async {
    final prefs = await SharedPreferences.getInstance();
    _favoris = prefs.getStringList(_keyFavoris)?.toSet() ?? {};
    notifyListeners(); // Informe les widgets de l'état initial
  }

  // Bascule l'état favori d'une photo
  Future<void> toggleFavori(Photo photo) async {
    final prefs = await SharedPreferences.getInstance();
    if (_favoris.contains(photo.id)) {
      _favoris.remove(photo.id);
    } else {
      _favoris.add(photo.id);
    }
    await prefs.setStringList(_keyFavoris, _favoris.toList()); // Sauvegarde
    notifyListeners(); // Informe les widgets du changement
  }

  // Vérifie si une photo est favorite
  bool estFavori(Photo photo) {
    return _favoris.contains(photo.id);
  }
}

// Cette classe est la Source Unique de Vérité pour tout ce qui concerne l'état partagé de l'application. C'est le grand grimoire que tous les magiciens (widgets) consultent et mettent à jour.

// Le Cerveau Central (AppState)
// Imagine que chaque écran est une personne différente. Au lieu qu'elles se parlent toutes entre elles dans un chaos total, elles parlent toutes à une seule entité : AppState. AppState maintient l'état actuel : "Nous sommes en mode sombre", "L'utilisateur veut une vue en grille", "Voici la liste des favoris". C'est le GameManager qui connaît la santé du joueur, son score, et son inventaire.

// Le Mégaphone (notifyListeners)
// Le ChangeNotifier donne à AppState un mégaphone. Chaque fois qu'une donnée importante est modifiée (via les méthodes toggle...), AppState prend son mégaphone et crie : "J'AI CHANGÉ !". Tous les widgets qui ont branché leurs écouteurs (Consumer ou context.watch) entendent ce cri et se mettent à jour en conséquence. C'est une implémentation simple et efficace du pattern Observer.

// La Forteresse des Données (Encapsulation)
// Les données réelles (les listes et variables avec _) sont privées. On ne peut pas y toucher directement de l'extérieur. Pour les modifier, on doit passer par les "portes" publiques que sont les méthodes (toggleTheme, toggleFavori). C'est un principe fondamental de la programmation orientée objet : protéger l'intégrité des données en contrôlant la manière dont elles sont modifiées. On ne change pas directement la vie du joueur ; on appelle une fonction PrendreDesDegats(10).

// En résumé, AppState est un gestionnaire d'état centralisé, réactif et bien encapsulé. C'est lui qui orchestre les changements de l'interface et assure que toutes les parties de l'application sont toujours synchronisées. C'est la pierre angulaire de l'architecture de cette application.
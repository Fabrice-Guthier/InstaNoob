import 'package:flutter/material.dart';
import 'package:likeit/models/photo.dart';
import 'package:likeit/services/photo_like_service.dart';

class AppState extends ChangeNotifier {
  Set<String> _photosFavoritesIds = {}; // Stocke seulement les IDs en mémoire
  final PhotoLikeService _photoLikeService =
      PhotoLikeService(); // Instance du service

  // -- Déclaration des États --

  // Le `_` au début du nom rend la variable privée au fichier. C'est l'encapsulation.
  // C'est la vraie liste où sont stockées les photos favorites.
  // On ne stocke plus les objets Photo, mais leurs IDs (String).
Set<String> get photosFavoritesIds => _photosFavoritesIds;

// Crée une instance de ton PhotoLikeService

  // État pour le thème (Clair / Sombre)
  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;

  // État pour le type d'affichage (Liste / Grille)
  bool _isGridView = false;
  bool get isGridView => _isGridView;

  // Constructeur : charge les favoris au démarrage
  AppState() {
    print(
      'AppState: Constructeur appelé. Démarrage du chargement des favoris.',
    );
    _loadFavoris();
  }

  // Charge les favoris depuis SharedPreferences
   Future<void> _loadFavoris() async {
    _photosFavoritesIds = await _photoLikeService
        .getLikedPhotoIds(); // Charge les IDs
    print(
      'AppState: Favoris chargés depuis SharedPreferences: ${_photosFavoritesIds.length} IDs.',
    );
    notifyListeners();
  }

  // Méthode pour Modifier l'État (les actions du joueur) --

  // Méthode pour basculer le thème
  void toggleTheme() {
    // Si le thème est clair, on passe en sombre, sinon on passe en clair.
    _themeMode = _themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    // LA LIGNE LA PLUS IMPORTANTE : On envoie un signal à tous les widgets qui écoutent !
    // "Hey tout le monde, le thème a changé, mettez-vous à jour !".
    notifyListeners();
  }

  // Méthode pour basculer la vue
  void toggleView() {
    _isGridView = !_isGridView; // On inverse simplement la valeur du booléen.
    notifyListeners(); // On notifie les widgets du changement.
  }

  // Méthode pour VÉRIFIER si une photo est déjà en favori.
  // C'est une méthode de "lecture" (query), elle ne modifie rien.
  bool estFavori(Photo photo) {
    // On vérifie si l'ID de la photo est dans la liste des IDs favoris.
    return _photosFavoritesIds.contains(photo.id);
  }

  // Méthode pour AJOUTER ou RETIRER une photo des favoris.
  Future<void> toggleFavori(Photo photo) async {
    print('AppState: toggleFavori appelé pour photo.id: ${photo.id}');
    if (estFavori(photo)) {
      await _photoLikeService.removeLikedPhotoId(
        photo.id,
      ); // Retire l'ID via le service
    } else {
      await _photoLikeService.addLikedPhotoId(
        photo.id,
      ); // Ajoute l'ID via le service
    }
    // Après la modification et la sauvegarde par le service, on rafraîchit notre copie en mémoire
    _photosFavoritesIds = await _photoLikeService.getLikedPhotoIds();

    print(
      'AppState: Sauvegarde et recharge terminées. Appelle notifyListeners().',
    );
    notifyListeners(); // Informe les widgets du changement
  }

  // Optionnel: Réinitialise tous les favoris
  Future<void> clearAllFavoris() async {
    await _photoLikeService.clearAllLikedPhotoIds();
    _photosFavoritesIds = {}; // Vide la liste en mémoire
    notifyListeners();
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

import 'package:flutter/material.dart';
import 'package:likeit/models/photo.dart';

class AppState extends ChangeNotifier {
  // Stockage des favoris en RAM
  final List<Photo> _photosFavorites = [];
  List<Photo> get photosFavorites => _photosFavorites;

  // État pour le thème (Light / Dark)
  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;

  // État pour l'affichage (Liste / Grille)
  bool _isGridView = false;
  bool get isGridView => _isGridView;

  // Méthodes pour modifier l'état et notifier les listeners
  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    notifyListeners(); // Informe les widgets du changement
  }

  void toggleView() {
    _isGridView = !_isGridView;
    notifyListeners();
  }

  bool estFavori(Photo photo) {
    return _photosFavorites.any((p) => p.id == photo.id);
  }

  void toggleFavori(Photo photo) {
    if (estFavori(photo)) {
      _photosFavorites.removeWhere((p) => p.id == photo.id);
    } else {
      _photosFavorites.add(photo);
    }
    notifyListeners();
  }
}

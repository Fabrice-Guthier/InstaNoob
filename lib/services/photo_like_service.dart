// lib/services/photo_like_service.dart
import 'package:shared_preferences/shared_preferences.dart';

class PhotoLikeService {
  // Clé unique pour stocker la liste des IDs de favoris
  static const String _keyLikedPhotosIds =
      'favoris_photos_ids_list'; // Clé dédiée aux IDs

  // Récupère la liste des IDs de photos likées
  Future<Set<String>> getLikedPhotoIds() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Récupère la liste de String et la convertit en Set pour l'unicité
      final List<String>? loadedIds = prefs.getStringList(_keyLikedPhotosIds);
      final Set<String> ids = loadedIds?.toSet() ?? {};
      print(
        'PhotoLikeService: ${ids.length} IDs favoris chargés depuis SharedPreferences.',
      );
      return ids;
    } catch (e) {
      print('PhotoLikeService: Erreur de lecture des IDs favoris: $e');
      return {};
    }
  }

  // Sauvegarde la liste complète des IDs de photos likées
  Future<void> _saveLikedPhotoIds(Set<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    // Sauvegarde le Set en le convertissant en List<String>
    await prefs.setStringList(_keyLikedPhotosIds, ids.toList());
    print(
      'PhotoLikeService: ${ids.length} IDs favoris sauvegardés dans SharedPreferences.',
    );
  }

  // Ajoute un ID de photo aux favoris
  Future<void> addLikedPhotoId(String photoId) async {
    Set<String> currentIds = await getLikedPhotoIds();
    if (currentIds.add(photoId)) {
      // add retourne true si l'élément a été ajouté (non déjà présent)
      await _saveLikedPhotoIds(currentIds);
      print(
        'PhotoLikeService: ID $photoId ajouté. Total: ${currentIds.length}',
      );
    } else {
      print('PhotoLikeService: ID $photoId déjà présent.');
    }
  }

  // Retire un ID de photo des favoris
  Future<void> removeLikedPhotoId(String photoId) async {
    Set<String> currentIds = await getLikedPhotoIds();
    if (currentIds.remove(photoId)) {
      // remove retourne true si l'élément a été retiré
      await _saveLikedPhotoIds(currentIds);
      print(
        'PhotoLikeService: ID $photoId retiré. Total: ${currentIds.length}',
      );
    } else {
      print('PhotoLikeService: ID $photoId non trouvé.');
    }
  }

  // Vérifie si un ID de photo est dans les favoris
  Future<bool> isPhotoIdLiked(String photoId) async {
    Set<String> currentIds = await getLikedPhotoIds();
    return currentIds.contains(photoId);
  }

  // Optionnel: Nettoie tous les IDs de favoris
  Future<void> clearAllLikedPhotoIds() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyLikedPhotosIds);
    print('PhotoLikeService: Tous les IDs favoris ont été supprimés.');
  }
}

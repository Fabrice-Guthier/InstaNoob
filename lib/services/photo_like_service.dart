import 'package:shared_preferences/shared_preferences.dart';

class PhotoLikeService {
  static const String _keyLikedPhotos = 'liked_photos_ids';

  // Ajoute une photo likée
  Future<void> addLikedPhoto(String photoId) async {
    final prefs = await SharedPreferences.getInstance();
    // Récupère la liste existante, ou une liste vide si elle n'existe pas
    Set<String> likedPhotos =
        prefs.getStringList(_keyLikedPhotos)?.toSet() ?? {};
    likedPhotos.add(photoId); // Ajoute le nouvel ID
    await prefs.setStringList(
      _keyLikedPhotos,
      likedPhotos.toList(),
    ); // Sauvegarde la liste
    print('Photo likée ajoutée : $photoId'); // Pour le débug
  }

  // Retire une photo likée
  Future<void> removeLikedPhoto(String photoId) async {
    final prefs = await SharedPreferences.getInstance();
    Set<String> likedPhotos =
        prefs.getStringList(_keyLikedPhotos)?.toSet() ?? {};
    likedPhotos.remove(photoId); // Retire l'ID
    await prefs.setStringList(
      _keyLikedPhotos,
      likedPhotos.toList(),
    ); // Sauvegarde la liste
    print('Photo likée retirée : $photoId'); // Pour le débug
  }

  // Récupère toutes les photos likées
  Future<Set<String>> getLikedPhotos() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keyLikedPhotos)?.toSet() ?? {};
  }

  // Vérifie si une photo est likée
  Future<bool> isPhotoLiked(String photoId) async {
    final prefs = await SharedPreferences.getInstance();
    Set<String> likedPhotos =
        prefs.getStringList(_keyLikedPhotos)?.toSet() ?? {};
    return likedPhotos.contains(photoId);
  }
}

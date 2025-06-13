
class Photo {
  final String id;
  final String auteur;
  final String url;
  final String description;

  Photo({
    required this.id,
    required this.auteur,
    required this.url,
    required this.description,
  });

  // Factory pour parser le JSON manuellement.
  // Un débutant ne connaît pas forcément les générateurs de code.
  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'] ?? 'id_inconnu',
      auteur: json['auteur'] ?? 'Auteur inconnu',
      url: json['url'] ?? '',
      description: json['description'] ?? 'Aucune description.',
    );
  }
}


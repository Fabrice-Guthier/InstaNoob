// La déclaration de la classe. C'est le plan de construction, le "blueprint" d'une photo.
// En C#, ce serait une simple classe POCO (Plain Old CLR Object).
class Photo {
  final String id;
  final String auteur; // Unsplash utilise 'user.name'
  final String url; // Unsplash a plusieurs tailles, on prendra 'urls.regular'
  final String
  description; // Unsplash utilise 'description' ou 'alt_description'

  Photo({
    required this.id,
    required this.auteur,
    required this.url,
    required this.description,
  });

  // Factory constructor pour créer une instance de Photo à partir d'un Map (JSON).
  // L'équivalent d'un constructeur prenant un DTO ou d'une méthode de fabrique statique en C#.
  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'] as String,
      auteur:
          (json['auteur'] as String?) ??
          (json['user']?['name'] as String?) ??
          'Inconnu', // Accès imbriqué pour l'auteur
      url:
          (json['url'] as String?) ?? // <-- AJOUTE CETTE LIGNE
          (json['urls']?['regular']
              as String?) ?? // Utilise l'opérateur ?. pour accéder à 'regular' en toute sécurité
          'https://via.placeholder.com/400x600?text=Erreur+Image', // Accès imbriqué pour l'URL de l'image
      description:
                  json['description'] as String? ??
                  json['alt_description'] as String? ??
                  'Pas de description', // Unsplash peut avoir null
    );
  }
}

// Cette classe est le schéma directeur d'une "Photo" dans l'application. Elle définit précisément de quelles informations une photo est composée.

// La Carte d'Identité (Propriétés final)
// En déclarant les propriétés avec final, on crée un objet immuable. Une fois qu'une photo est créée avec son ID, son auteur, etc., ces informations ne peuvent plus changer. C'est comme graver des stats sur une carte de collection. Si quelque chose doit changer, on crée une nouvelle carte. Cette pratique rend le code beaucoup plus sûr, car on sait qu'un objet Photo ne sera pas modifié accidentellement ailleurs dans le code.

// Le Traducteur Universel (fromJson)
// C'est la fonction la plus intelligente de cette classe. Elle sert d'interprète entre le langage "brut" et potentiellement chaotique d'une API (le JSON) et le langage "propre" et structuré de ton application (l'objet Photo).

// Entrée : Du JSON (représenté par une Map).
// Sortie : Un bel objet Photo, bien typé, avec toutes ses propriétés garanties.
// La sécurité ajoutée par l'opérateur ?? est primordiale. C'est un garde du corps qui s'assure que même si l'API renvoie des données incomplètes, ton application ne plantera pas. Elle affichera "Auteur inconnu" au lieu de crasher, ce qui est une expérience utilisateur bien meilleure.
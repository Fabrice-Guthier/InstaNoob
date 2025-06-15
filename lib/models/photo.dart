// La déclaration de la classe. C'est le plan de construction, le "blueprint" d'une photo.
// En C#, ce serait une simple classe POCO (Plain Old CLR Object).
class Photo {
  // Les propriétés de la classe. Le mot-clé `final` est très important :
  // il signifie que lorsque l'objet Photo est créé, ces valeurs ne pourront JAMAIS être modifiées.
  // C'est un objet immuable, ce qui rend l'état de l'application beaucoup plus prévisible et sûr.
  final String id;
  final String auteur;
  final String url;
  final String description;

  // Le constructeur de la classe.
  // Le mot-clé `required` garantit qu'on ne peut pas créer une Photo sans fournir toutes ces informations.
  Photo({
    required this.id,
    required this.auteur,
    required this.url,
    required this.description,
  });

  // Un "factory constructor". C'est une méthode spéciale qui fabrique un objet de la classe.
  // Son rôle ici est de servir de "traducteur" depuis le format JSON.
  // Elle prend une `Map` (qui représente le JSON) et la transforme en un objet `Photo` propre.
  factory Photo.fromJson(Map<String, dynamic> json) {
    // On retourne une nouvelle instance de Photo.
    return Photo(
      // Pour chaque propriété, on essaie de lire la valeur correspondante dans le JSON.
      // L'opérateur `??` est une sécurité (null-coalescing).
      // Il dit : "Essaie de prendre `json['id']`. Si c'est null, alors utilise 'id_inconnu' à la place."
      // C'est une protection vitale contre les données incomplètes ou malformées d'une API.
      // Ça évite que l'application ne crash.
      id: json['id'] ?? 'id_inconnu',
      auteur: json['auteur'] ?? 'Auteur inconnu',
      url: json['url'] ?? '',
      description: json['description'] ?? 'Aucune description.',
    );
  }
}

// Cette classe est le schéma directeur d'une "Photo" dans ton application. Elle définit précisément de quelles informations une photo est composée.

// La Carte d'Identité (Propriétés final)
// En déclarant les propriétés avec final, on crée un objet immuable. Une fois qu'une photo est créée avec son ID, son auteur, etc., ces informations ne peuvent plus changer. C'est comme graver des stats sur une carte de collection. Si quelque chose doit changer, on crée une nouvelle carte. Cette pratique rend le code beaucoup plus sûr, car on sait qu'un objet Photo ne sera pas modifié accidentellement ailleurs dans le code.

// Le Traducteur Universel (fromJson)
// C'est la fonction la plus intelligente de cette classe. Elle sert d'interprète entre le langage "brut" et potentiellement chaotique d'une API (le JSON) et le langage "propre" et structuré de ton application (l'objet Photo).

// Entrée : Du JSON (représenté par une Map).
// Sortie : Un bel objet Photo, bien typé, avec toutes ses propriétés garanties.
// La sécurité ajoutée par l'opérateur ?? est primordiale. C'est un garde du corps qui s'assure que même si l'API renvoie des données incomplètes, ton application ne plantera pas. Elle affichera "Auteur inconnu" au lieu de crasher, ce qui est une expérience utilisateur bien meilleure.
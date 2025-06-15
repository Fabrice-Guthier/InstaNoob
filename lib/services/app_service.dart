// Importe la bibliothèque 'faker', un outil génial pour créer de fausses données.
// C'est notre générateur de quêtes aléatoires. Parfait pour tester sans vrai serveur.
import 'package:faker/faker.dart';
// Importe le modèle de données 'Photo'. Il faut bien savoir à quoi ressemblent les "trésors" qu'on récupère.
import 'package:likeit/models/photo.dart';

// Une classe de "service" a pour rôle de gérer une logique spécifique, souvent la communication
// avec une source de données (API, base de données, etc.).
class ApiService {
  // Déclare une méthode 'recupererPhotos'.
  // 'Future' indique que c'est une opération asynchrone : elle ne donnera pas son résultat tout de suite.
  // En C#, c'est l'équivalent parfait de `public async Task<List<Photo>> RecupererPhotos()`.
  Future<List<Photo>> recupererPhotos() async {
    // `await` met en pause l'exécution de CETTE fonction pendant 1 seconde, SANS bloquer l'interface utilisateur.
    // C'est fait pour simuler le temps d'attente d'une vraie requête réseau.
    // L'app reste fluide, comme un jeu qui charge le niveau suivant en arrière-plan.
    await Future.delayed(const Duration(seconds: 1));

    // On crée une instance de notre générateur de fausses données.
    final faker = Faker();

    // On génère une liste de 100 faux objets JSON. C'est le "loot" brut qu'on recevrait d'un serveur.
    final faussesDonneesJson = List.generate(100, (index) {
      // Pour chaque élément, on crée une map (similaire à un dictionnaire C# ou un objet JS).
      return {
        'id': faker.guid.guid(), // Un ID unique
        'auteur': faker.person.name(), // Un nom d'auteur aléatoire
        // Une URL vers le service Picsum Photos pour avoir de vraies images.
        // La seed aléatoire garantit qu'on n'a pas 100x la même image.
        'url': 'https://picsum.photos/seed/${faker.randomGenerator.string(10)}/400/600',
        'description': faker.lorem.sentence(), // Une fausse description
      };
    });

    // Étape finale : la transformation. On prend la liste de JSON brut...
    // `.map()` parcourt chaque élément JSON de la liste...
    // `Photo.fromJson(json)` appelle une méthode (probablement un constructeur factory) sur la classe Photo
    // pour transformer le JSON en un véritable objet Dart, fortement typé.
    // C'est l'équivalent de la désérialisation en C# (ex: `JsonConvert.DeserializeObject<Photo>`).
    // `.toList()` convertit le résultat final en une liste.
    return faussesDonneesJson.map((json) => Photo.fromJson(json)).toList();
  }
}

// Ce fichier, ApiService.dart, est un simulateur de serveur. Son unique mission est de faire semblant de contacter une API sur internet pour récupérer une liste de photos.

// Pourquoi faire semblant ? (Le "Mock")
// En développement, le backend (le serveur qui a les vraies données) n'est pas toujours prêt en même temps que l'interface utilisateur (frontend). Pour ne pas être bloqué, on crée un "faux" service comme celui-ci. Il renvoie des données crédibles, ce qui permet de construire et tester l'application comme si on avait une vraie connexion. C'est comme s'entraîner sur des mannequins de combat avant d'affronter de vrais monstres.

// La Magie de l'Asynchrone (async/await)
// La ligne await Future.delayed(const Duration(seconds: 1)); est la plus importante pour comprendre le concept. Une vraie requête réseau prend du temps. Si l'application se figeait pendant ce temps, l'utilisateur serait frustré.
// Grâce à async et await, l'application lance la requête et dit : "Ok, ça va prendre un peu de temps. Pendant ce temps, je continue à faire ma vie (je reste réactive aux clics, je continue les animations...)". Quand la réponse arrive enfin, le code reprend là où il s'était arrêté. C'est la base d'une application fluide.

// La Forge (Photo.fromJson)
// Le service reçoit des données brutes (le JSON). Mais le reste de l'application préfère travailler avec des objets propres et bien définis (des instances de la classe Photo). La dernière ligne est une chaîne de transformation : elle prend chaque morceau de "minerai" JSON et le "forge" pour en faire une "épée" Photo, un objet que le code peut manipuler facilement et en toute sécurité.

// En résumé, cette classe est un fournisseur de données de test qui imite le comportement d'une vraie API, notamment son temps de réponse, et qui s'assure de livrer des données propres et prêtes à l'emploi pour le reste de l'application.
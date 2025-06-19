// Pour les requêtes HTTP, on a besoin d'un bon vieux 'http' package.
// C'est notre client REST, prêt à envoyer des requêtes comme un guerrier en quête de loot.
import 'package:http/http.dart' as http;
import 'dart:convert'; // Pour décoder le JSON, parce que les données d'API, c'est souvent ça.

// Importe le modèle de données 'Photo'. On va mapper les données Unsplash là-dessus.
import 'package:likeit/models/photo.dart';

// Constante pour notre clé d'API Unsplash.
const String unsplashAccessKey =
    '4WCnYuEhE8CttpLHbB0ADdMWGHBla3PlITvUwTZFDm0';

class ApiService {
  // Méthode asynchrone pour récupérer les photos d'Unsplash.
  Future<List<Photo>> recupererPhotos() async {
    // L'URL de l'API Unsplash pour récupérer une liste de photos.
    final uri = Uri.parse('https://api.unsplash.com/photos?per_page=30');

    try {
      // Exécute la requête HTTP GET. C'est notre `HttpClient.GetAsync()`
      // qui va chercher les données sur le réseau.
      final response = await http.get(
        uri,
        headers: {
          // L'authentification
          'Authorization': 'Client-ID $unsplashAccessKey',
        },
      );

      // Vérifie le code de statut de la réponse HTTP.
      // Si c'est 200 OK, la requête a réussi, comme un sort qui touche sa cible.
      if (response.statusCode == 200) {
        // Décode le corps de la réponse JSON en une liste dynamique.
        final List<dynamic> jsonList = json.decode(response.body);

        // Transforme la liste de JSON brut en une liste d'objets Photo.
        // Chaque élément JSON est mappé à notre modèle Photo.
        return jsonList.map((json) => Photo.fromJson(json)).toList();
      } else {
        // Gère les erreurs de l'API, par exemple si la clé est invalide ou si la limite est atteinte.
        throw Exception(
          'Échec de chargement des photos Unsplash : ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      // Capture toute exception qui pourrait survenir pendant la requête (problèmes réseau, etc.).
      throw Exception('Erreur réseau ou de parsing des données Unsplash : $e');
    }
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
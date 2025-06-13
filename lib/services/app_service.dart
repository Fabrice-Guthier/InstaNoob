import 'package:faker/faker.dart';
import 'package:likeit/models/photo.dart';

class ApiService {
  Future<List<Photo>> recupererPhotos() async {
    // On simule un délai réseau, comme si on attendait une vraie réponse
    await Future.delayed(const Duration(seconds: 1));

    // On utilise faker pour générer de fausses données JSON
    final faker = Faker();
    final faussesDonneesJson = List.generate(20, (index) {
      return {
        'id': faker.guid.guid(),
        'auteur': faker.person.name(),
        'url':
            'https://picsum.photos/seed/${faker.randomGenerator.string(10)}/400/600',
        'description': faker.lorem.sentence(),
      };
    });

    // On transforme la liste de JSON en liste d'objets Dart
    return faussesDonneesJson.map((json) => Photo.fromJson(json)).toList();
  }
}

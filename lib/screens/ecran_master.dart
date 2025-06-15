import 'package:flutter/material.dart';
import 'package:likeit/models/photo.dart';
import 'package:likeit/providers/app_state.dart';
import 'package:likeit/services/app_service.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EcranMaster extends StatefulWidget {
  const EcranMaster({super.key});

  @override
  State<EcranMaster> createState() => _EcranMasterState();
}

class _EcranMasterState extends State<EcranMaster> {
  late Future<List<Photo>> _futurePhotos;

  @override
  void initState() {
    super.initState();
    _futurePhotos = ApiService().recupererPhotos();
  }

  @override
  Widget build(BuildContext context) {
    // On récupère une instance du provider pour l'utiliser dans les boutons
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Insta-Noob'),
        actions: [
          // Bouton pour changer le thème
          IconButton(
            icon: Icon(
              appState.themeMode == ThemeMode.light
                  ? Icons.dark_mode_outlined
                  : Icons.light_mode_outlined,
            ),
            onPressed: () => appState.toggleTheme(),
          ),
          // Bouton pour changer la vue
          IconButton(
            icon: Icon(
              appState.isGridView
                  ? Icons.view_list_outlined
                  : Icons.grid_view_outlined,
            ),
            onPressed: () => appState.toggleView(),
          ),
          // Bouton pour voir les favoris
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () => Navigator.pushNamed(context, '/favoris'),
          ),
        ],
      ),
      body: FutureBuilder<List<Photo>>(
        future: _futurePhotos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Une erreur est survenue: ${snapshot.error}'),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucune photo à afficher.'));
          }

          final photos = snapshot.data!;
          return appState.isGridView
              ? GrillePhotos(photos: photos)
              : ListePhotos(photos: photos);
        },
      ),
    );
  }
}

// Widget pour la vue en liste
class ListePhotos extends StatelessWidget {
  final List<Photo> photos;
  const ListePhotos({super.key, required this.photos});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: photos.length,
      itemBuilder: (context, index) {
        final photo = photos[index];
        return CartePhoto(photo: photo);
      },
    );
  }
}

// Widget pour la vue en grille
class GrillePhotos extends StatelessWidget {
  final List<Photo> photos;
  const GrillePhotos({super.key, required this.photos});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        final photo = photos[index];
        return CartePhoto(photo: photo);
      },
    );
  }
}

class CartePhoto extends StatelessWidget {
  final Photo photo;
  const CartePhoto({super.key, required this.photo});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigation vers l'écran de détails en passant la photo
        Navigator.pushNamed(context, '/details', arguments: photo);
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.all(8.0),
        elevation: 3,
        child: Column(
          children: [
            // Utilisation de la mise en cache
            CachedNetworkImage(
              imageUrl: photo.url,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                height: 150,
                color: Colors.grey[300],
                child: const Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => Container(
                height: 150,
                color: Colors.red[100],
                child: const Icon(Icons.broken_image),
              ),
            ),
            // Affichage de l'auteur et du bouton like
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(photo.auteur, overflow: TextOverflow.ellipsis),
                  ),
                  Consumer<AppState>(
                    builder: (context, appState, child) {
                      return IconButton(
                        icon: Icon(
                          appState.estFavori(photo)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: appState.estFavori(photo) ? Colors.red : null,
                        ),
                        onPressed: () => appState.toggleFavori(photo),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

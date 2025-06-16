import 'package:flutter/material.dart';
import 'package:likeit/models/photo.dart';
import 'package:likeit/providers/app_state.dart';
import 'package:likeit/services/app_service.dart';
import 'package:provider/provider.dart';
// Importe une bibliothèque externe pour gérer le cache des images. C'est un "mod" très utile.
import 'package:cached_network_image/cached_network_image.dart';

// -- L'ÉCRAN PRINCIPAL (LE CONTENEUR) --
// C'est un StatefulWidget car il doit gérer une opération longue : le chargement des données.
class EcranMaster extends StatefulWidget {
  const EcranMaster({super.key});

  @override
  // Crée l'état mutable pour ce widget.
  State<EcranMaster> createState() => _EcranMasterState();
}

// -- LA LOGIQUE ET L'AFFICHAGE DE L'ÉCRAN --
class _EcranMasterState extends State<EcranMaster> {
  // Une variable qui va contenir le résultat "futur" de notre appel API.
  // Elle commence vide, mais contiendra soit les données, soit une erreur.
  late Future<List<Photo>> _futurePhotos;

  @override
  void initState() {
    super.initState();
    // `initState` est appelé UNE SEULE FOIS, à la création du widget.
    // C'est l'endroit parfait pour lancer des opérations d'initialisation, comme une requête réseau.
    // On lance la quête pour récupérer les photos !
    _futurePhotos = ApiService().recupererPhotos();
  }

  @override
  Widget build(BuildContext context) {
    // On récupère l'état global de l'app. On a besoin de ses données pour afficher les bonnes icônes.
    // `listen: true` (par défaut) signifie que si `appState` change, ce widget sera reconstruit.
    final appState = context.watch<AppState>();

    // `Scaffold` est la structure de base d'un écran Material Design.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insta-Débutant'),
        actions: [ // La liste des boutons à droite dans la barre de titre.
          // Bouton pour changer le thème
          IconButton(
            // On choisit l'icône en fonction du thème actuel, lu depuis l'état global.
            icon: Icon(appState.themeMode == ThemeMode.light
                ? Icons.dark_mode_outlined
                : Icons.light_mode_outlined),
            // Au clic, on appelle la méthode de l'état global pour changer le thème.
            onPressed: () => appState.toggleTheme(),
          ),
          // Bouton pour changer la vue (liste ou grille)
          IconButton(
            icon: Icon(appState.isGridView
                ? Icons.view_list_outlined
                : Icons.grid_view_outlined),
            onPressed: () => appState.toggleView(),
          ),
          // Bouton pour naviguer vers l'écran des favoris
          IconButton(
            icon: const Icon(Icons.favorite_border),
            // `Navigator.pushNamed` est notre système de "téléportation" vers une autre route/écran.
            onPressed: () => Navigator.pushNamed(context, '/favoris'),
          ),
        ],
      ),
      // -- LE CORPS DE L'ÉCRAN : GESTION DE LA DONNÉE ASYNCHRONE --
      body: FutureBuilder<List<Photo>>(
        // Le `FutureBuilder` est un widget incroyable qui gère pour nous les états d'une opération asynchrone.
        future: _futurePhotos, // On lui donne la quête à surveiller.
        builder: (context, snapshot) {
          // Cas 1 : La quête est en cours...
          if (snapshot.connectionState == ConnectionState.waiting) {
            // On affiche un indicateur de chargement.
            return const Center(child: CircularProgressIndicator());
          }
          // Cas 2 : La quête a échoué !
          if (snapshot.hasError) {
            return Center(child: Text('Une erreur est survenue: ${snapshot.error}'));
          }
          // Cas 3 : La quête est terminée, mais n'a ramené aucun trésor.
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucune photo à afficher.'));
          }

          // Cas 4 : Succès ! On a reçu le butin.
          final photos = snapshot.data!;
          // On regarde l'état global pour décider comment afficher les photos.
          return appState.isGridView
              ? GrillePhotos(photos: photos)
              : ListePhotos(photos: photos);
        },
      ),
    );
  }
}

// -- WIDGETS D'AFFICHAGE RÉUTILISABLES --

// Widget pour la vue en liste
class ListePhotos extends StatelessWidget {
  final List<Photo> photos;
  const ListePhotos({super.key, required this.photos});

  @override
  Widget build(BuildContext context) {
    // `ListView.builder` est optimisé : il ne crée que les éléments visibles à l'écran.
    return ListView.builder(
      itemCount: photos.length,
      itemBuilder: (context, index) => CartePhoto(photo: photos[index]),
    );
  }
}

// Widget pour la vue en grille
class GrillePhotos extends StatelessWidget {
  final List<Photo> photos;
  const GrillePhotos({super.key, required this.photos});

  @override
  Widget build(BuildContext context) {
    // `GridView.builder` fait la même chose, mais pour une grille.
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 colonnes
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) => CartePhoto(photo: photos[index]),
    );
  }
}

// -- LA CARTE INDIVIDUELLE POUR UNE PHOTO --
class CartePhoto extends StatelessWidget {
  final Photo photo;
  const CartePhoto({super.key, required this.photo});

  @override
  Widget build(BuildContext context) {
    // On rend la carte entière cliquable pour aller aux détails.
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/details', arguments: photo),
      child: Card(
        clipBehavior: Clip.antiAlias, // Pour que l'image respecte les coins arrondis
        margin: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Ce widget est un dieu : il télécharge l'image, l'affiche, ET la met en cache.
            // La prochaine fois, l'image se chargera instantanément depuis le disque.
            Hero(
              tag: photo.id, // Tag unique pour l'animation de transition
              child: CachedNetworkImage(
                imageUrl: photo.url,
                fit: BoxFit.cover,
                // Ce qu'on affiche PENDANT le chargement.
                placeholder: (context, url) => Container(
                    height: 150,
                    color: Colors.grey[300],
                    child: const Center(child: CircularProgressIndicator())),
                // Ce qu'on affiche SI le chargement échoue.
                errorWidget: (context, url, error) => Container(
                    height: 150,
                    color: Colors.red[100],
                    child: const Icon(Icons.broken_image)),
              ),
            ),
            // La barre d'infos sous l'image
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text(photo.auteur, overflow: TextOverflow.ellipsis)),
                  // -- LE BOUTON LIKE "INTELLIGENT" --
                  // On utilise un Consumer ici. C'est une optimisation CLÉ.
                  // Seul ce bouton sera reconstruit quand l'état des favoris change,
                  // pas toute la carte, ni toute la liste. C'est ultra performant.
                  Consumer<AppState>(
                    builder: (context, appState, child) {
                      final estFavori = appState.estFavori(photo);
                      return IconButton(
                        icon: Icon(
                          estFavori ? Icons.favorite : Icons.favorite_border,
                          color: estFavori ? Colors.red : null,
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


// Ce fichier définit tout ce qui se passe sur l'écran d'accueil de l'application. C'est la pièce maîtresse qui assemble tous les autres éléments qu'on a vus.

// Le Cycle de Vie de l'Écran (initState)
// Dès que l'écran apparaît, il lance immédiatement la "quête" pour récupérer les photos (ApiService.recupererPhotos()). Il ne reste pas les bras croisés à attendre le joueur.

// L'Affichage Intelligent (FutureBuilder)
// C'est le "journal de quêtes" de l'interface. Il surveille la quête lancée dans initState et met à jour l'affichage en temps réel :

// "Quête en cours..." → Il affiche une roue de chargement.
// "Échec de la quête !" → Il affiche un message d'erreur.
// "Quête réussie !" → Il affiche enfin les photos.
// Le Centre de Commandement (AppBar et Provider)
// La barre en haut de l'écran n'est pas juste décorative. C'est un tableau de bord. Les boutons (changer de thème, changer de vue) ne font pas le travail eux-mêmes ; ils envoient des ordres à l'état global (appState). L'état global se met à jour, et l'interface qui en dépend (comme l'icône du bouton ou le corps de la page) se met à jour automatiquement.

// L'Arsenal d'Affichage (ListePhotos & GrillePhotos)
// Au lieu de mettre un énorme bloc de code dans EcranMaster, on a créé des "plans de construction" (ListePhotos et GrillePhotos). L'écran principal choisit simplement quel plan utiliser en fonction des ordres du appState. C'est propre et réutilisable.

// La Carte d'Identité (CartePhoto)
// C'est la brique de base. Elle est super optimisée :

// Mise en Cache (CachedNetworkImage) : Elle télécharge les images une seule fois. C'est comme garder une carte des zones déjà explorées pour ne pas avoir à redécouvrir le chemin. C'est rapide et ça économise la data.
// Like Chirurgical (Consumer) : Quand tu cliques sur "like", seule la petite icône du cœur se redessine. Pas la carte, pas la liste, juste le cœur. C'est une optimisation de performance majeure pour que l'app reste fluide même avec des centaines de photos.
// En résumé, EcranMaster est un chef d'orchestre intelligent. Il délègue la récupération des données, gère proprement tous les états de chargement, affiche les données de manière flexible et réagit aux actions de l'utilisateur de la manière la plus performante possible.
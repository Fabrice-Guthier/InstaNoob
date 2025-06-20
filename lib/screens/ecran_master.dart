import 'package:flutter/material.dart';
import 'package:likeit/models/photo.dart';
import 'package:likeit/providers/app_state.dart';
import 'package:likeit/services/photo_service.dart';
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
        title: const Text('InstaNooB'),
        actions: [
          // La liste des boutons à droite dans la barre de titre.
          // Bouton pour changer le thème
          IconButton(
            // On choisit l'icône en fonction du thème actuel, lu depuis l'état global.
            icon: Icon(
              appState.themeMode == ThemeMode.light
                  ? Icons.dark_mode_outlined
                  : Icons.light_mode_outlined,
            ),
            // Au clic, on appelle la méthode de l'état global pour changer le thème.
            onPressed: () => appState.toggleTheme(),
          ),
          // Bouton pour changer la vue (liste ou grille)
          IconButton(
            icon: Icon(
              appState.isGridView
                  ? Icons.view_list_outlined
                  : Icons.grid_view_outlined,
            ),
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
        //----------------------------------------------------------------------------------------
        //builder: (context, snapshot): C'est le cœur de la logique. Le builder est une fonction qui sera appelée par Flutter à chaque fois que l'état de la quête (_futurePhotos) change. Elle prend deux arguments :
        // context: Le contexte de l'arbre des widgets, un grand classique en Flutter.
        // snapshot: C'est la star du spectacle ! À chaque fois que le builder est appelé, ce snapshot est un nouvel objet AsyncSnapshot qui contient une photo à l'instant T de l'avancement de ta quête _futurePhotos.
        //----------------------------------------------------------------------------------------
        builder: (context, snapshot) {
          // Cas 1 : La quête est en cours...
          if (snapshot.connectionState == ConnectionState.waiting) {
            // On affiche un indicateur de chargement.
            return const Center(child: CircularProgressIndicator());
          }
          // Cas 2 : La quête a échoué !
          if (snapshot.hasError) {
            return Center(
              child: Text('Une erreur est survenue: ${snapshot.error}'),
            );
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
      // On modifie juste cette ligne :
      itemBuilder: (context, index) {
        // On met la carte dans une boîte avec une hauteur fixe
        return SizedBox(
          height: 500, // Joue avec cette valeur pour trouver la taille idéale !
          child: CartePhoto(photo: photos[index]),
        );
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
    // `GridView.builder` fait la même chose, mais pour une grille.
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 colonnes
        childAspectRatio: 0.7, // Ajuste le ratio pour que les cartes soient plus hautes que larges
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
        clipBehavior:
            Clip.antiAlias, // Pour que l'image respecte les coins arrondis
        margin: const EdgeInsets.all(8.0),
        child: Stack(
          // On s'assure que le Stack remplit bien toute la carte.
          fit: StackFit.expand,
          children: [
            // --- COUCHE N°1 (LE FOND) : L'IMAGE ---
            // L'image ne change pas, mais elle est maintenant la base de notre superposition.
            Hero(
              tag: photo.id, // Tag unique pour l'animation de transition
              child: CachedNetworkImage(
                imageUrl: photo.url,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[300],
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.red[100],
                  child: const Icon(Icons.broken_image),
                ),
              ),
            ),

            // --- COUCHE N°2 (PAR-DESSUS) : LE BOUTON LIKE ---
            Align(
              alignment: Alignment.bottomRight, // On le cale en bas à droite.
              child: Consumer<AppState>(
                builder: (context, appState, child) {
                  final estFavori = appState.estFavori(photo);
                  return IconButton(
                    // On peut augmenter un peu la taille pour une meilleure visibilité.
                    iconSize: 32,
                    icon: Icon(
                      estFavori ? Icons.favorite : Icons.favorite_border,
                      // ASTUCE : On met l'icône en blanc avec une ombre
                      // pour qu'elle soit visible sur n'importe quelle photo !
                      color: estFavori ? Colors.redAccent : Colors.white,
                      shadows: const [
                        Shadow(color: Colors.black87, blurRadius: 6.0),
                      ],
                    ),
                    onPressed: () => appState.toggleFavori(photo),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Ce que fait ce fichier, en résumé
// Pense à ce fichier comme au niveau principal de ton jeu. Il gère tout ce qui se passe sur l'écran d'accueil.

// Son rôle est celui d'un chef d'orchestre intelligent :

// Il lance la quête (dès le début) : Au lancement de l'écran, il envoie immédiatement un messager (ApiService) chercher les photos sur internet. Il n'attend pas.

// Il gère l'attente (le journal de quêtes) : Pendant que le messager est parti, il affiche un écran de chargement (FutureBuilder).

// Si le messager revient avec les photos, super ! Il les affiche.

// Si le messager tombe dans un piège (erreur réseau), il affiche un message d'erreur.

// C'est robuste, il pense à tous les scénarios.

// Il écoute les ordres du joueur (le tableau de bord) : La barre de titre (AppBar) contient des boutons. Quand tu cliques dessus (changer la vue, le thème...), l'écran ne change pas directement. Il envoie un ordre à un "manager central" (AppState), et c'est ce manager qui dit à l'écran comment se redessiner. C'est propre et organisé.

// Il utilise des plans de construction réutilisables :

// ListePhotos et GrillePhotos : Au lieu de coder l'affichage en liste et en grille directement dans l'écran principal, il utilise des "plans" séparés. C'est plus facile à maintenir.

// CartePhoto : C'est la brique de base, la carte individuelle pour une seule photo. Elle est super optimisée :

// Elle superpose le bouton ❤️ sur l'image (Stack).

// Elle met les images en cache pour que l'app soit rapide (CachedNetworkImage).

// Elle a une animation de transition fluide (Hero).

// En bref, ce fichier est le cerveau de ton écran d'accueil. Il est proactif, gère les imprévus et délègue le travail à des composants spécialisés pour que tout reste propre, performant et facile à modifier.

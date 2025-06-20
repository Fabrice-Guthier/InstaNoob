import 'package:flutter/material.dart';
import 'package:likeit/models/photo.dart';
import 'package:likeit/providers/app_state.dart';
// On importe EcranMaster UNIQUEMENT pour pouvoir réutiliser le widget 'ListePhotos' qui s'y trouve.
// C'est une dépendance directe, ce qui montre à quel point les composants sont bien couplés.
import 'package:likeit/screens/ecran_master.dart';
import 'package:likeit/services/photo_service.dart';
import 'package:provider/provider.dart';

// L'écran des favoris est un 'StatelessWidget'.
// C'est un choix parfait : il n'a aucune logique ou état interne.
// Sa seule mission est d'afficher une liste qui lui est fournie par quelqu'un d'autre (AppState).
// C'est un PNJ (Personnage Non-Joueur) avec un script simple : "Montre-moi les favoris".
class EcranFavoris extends StatelessWidget {
  const EcranFavoris({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        // Récupère les IDs des photos favorites depuis AppState
        final Set<String> favorisIds =
            appState.photosFavoritesIds; // <-- RÉCUPÈRE LES IDS

        return Scaffold(
          appBar: AppBar(title: const Text('Mes Favoris')),
          body: FutureBuilder<List<Photo>>(
            // Récupère TOUTES les photos de l'API à chaque fois
            future: ApiService().recupererPhotos(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Erreur: ${snapshot.error}'));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('Aucune photo à afficher de l\'API.'),
                );
              }

              final allPhotosFromApi = snapshot.data!;

              // Filtre les photos pour ne garder que celles dont l'ID est dans nos favoris persistants
              final List<Photo> favorisPhotos = allPhotosFromApi
                  .where((photo) => favorisIds.contains(photo.id))
                  .toList();

              if (favorisPhotos.isEmpty) {
                return const Center(
                  child: Text(
                    'Votre collection de trésors favoris est vide pour le moment. Allez liker quelques clichés !',
                  ),
                );
              }

              return ListView.builder(
                itemCount: favorisPhotos.length,
                itemBuilder: (context, index) => SizedBox(
                  height: 800, // Ajuste selon tes besoins
                  child: CartePhoto(photo: favorisPhotos[index]),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

// Cet écran est la "salle des trophées" de l'application. 
//Il n'a qu'un seul rôle : afficher la liste des photos que l'utilisateur a marquées comme favorites.

// Un Écran "Miroir" (StatelessWidget)
// Cet écran est volontairement "bête". 
//Il n'a pas besoin de sa propre mémoire ou de sa propre logique complexe. 
//Il se contente de refléter une partie de l'état global de l'application (AppState). 
//Si l'état change, le miroir met à jour son reflet.
//C'est un principe de conception très efficace : créer des composants simples et spécialisés.

// Toujours à Jour (Consumer)
// Grâce au Consumer, cet écran est magiquement connecté à la liste des favoris. 
//Si tu es sur l'écran principal (EcranMaster), que tu "likes" une photo, puis que tu navigues vers cet écran EcranFavoris, la nouvelle photo y apparaîtra instantanément. 
//Il n'y a pas besoin de "rafraîchir" manuellement la page. Le Consumer garantit que l'affichage est toujours synchronisé avec la source de vérité (AppState).

// Le Principe du LEGO (ListePhotos)
// C'est la démonstration la plus claire du principe DRY (Don't Repeat Yourself - Ne vous répétez pas). Les développeurs ont créé un widget, ListePhotos, qui sait parfaitement comment afficher une liste de Photo.

// Sur EcranMaster, on lui donne la liste complète des photos.
// Sur EcranFavoris, on lui donne la liste filtrée des favoris.
// C'est comme avoir une brique de LEGO "Afficheur de liste". On peut la brancher n'importe où et lui donner des données différentes, elle fera toujours son travail. C'est propre, maintenable, et ça évite les bugs liés à la duplication de code. En C#, ce serait l'équivalent d'un UserControl ou d'un composant Blazor que tu pourrais réutiliser sur différentes pages.

// En résumé, EcranFavoris est un exemple parfait d'un écran spécialisé, réactif et économe en code grâce à une bonne architecture basée sur un état central et des composants réutilisables.
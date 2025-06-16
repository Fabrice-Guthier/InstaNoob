// Imports nécessaires pour afficher l'image mise en cache, les widgets de base et connaître la structure d'une 'Photo'.
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:likeit/models/photo.dart';

// Un widget 'Stateless' car il ne fait qu'afficher des données qu'on lui donne.
// Il n'a pas d'état interne qui change. C'est une page de lecture seule.
class EcranDetail extends StatelessWidget {
  const EcranDetail({super.key});

  @override
  Widget build(BuildContext context) {
    // -- LA LIGNE LA PLUS IMPORTANTE --
    // On récupère l'objet 'Photo' qui a été passé comme "argument" lors de la navigation.
    // Dans 'CartePhoto', on a fait : Navigator.pushNamed(context, '/details', arguments: photo).
    // Cette ligne-ci est la réception de ce "colis".
    final photo = ModalRoute.of(context)!.settings.arguments as Photo;

    // Structure de base de la page.
    return Scaffold(
      // La barre de titre affiche dynamiquement le nom de l'auteur de la photo.
      appBar: AppBar(title: Text(photo.auteur)),
      // Le corps de la page est enveloppé dans un `SingleChildScrollView`.
      // C'est une sécurité : si l'image + la description sont plus grandes que l'écran,
      // cela permet à l'utilisateur de scroller au lieu d'avoir un bug d'overflow.
      body: SingleChildScrollView(
        child: Column(
          // Aligne les enfants au début (à gauche par défaut).
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // On affiche l'image en grand format, en réutilisant notre super widget
            // qui gère le cache pour nous. C'est efficace !
            CachedNetworkImage(imageUrl: photo.url),
            // On ajoute un peu d'espace autour de la description pour que ça respire.
            Padding(
              padding: const EdgeInsets.all(16.0),
              // On affiche le texte de la description de la photo.
              child: Text(photo.description),
            ),
          ],
        ),
      ),
    );
  }
}

// Cet écran a une seule et unique mission : afficher en grand les détails d'une seule photo. C'est la loupe de l'application.

// La Réception du Colis (ModalRoute)
// Contrairement aux autres écrans qui écoutaient l'état global (Provider), cet écran reçoit ses informations directement au moment où on navigue vers lui. C'est comme un PNJ à qui on donne un objet précis en lui disant "Parle-moi de ça". Il n'a pas besoin de connaître tout l'inventaire du joueur (AppState), juste l'objet qu'on lui a mis dans les mains (arguments). C'est une manière très propre de passer des données pour un affichage ponctuel.

// Un Simple Lecteur (StatelessWidget)
// Cet écran est "stateless" car il est passif. Il reçoit une Photo, l'affiche, et c'est tout. Il ne modifie pas de données, ne lance pas de requêtes, ne gère pas de favoris. Sa simplicité est sa force : il est léger, rapide, et facile à comprendre.

// Prévenir les Problèmes (SingleChildScrollView)
// Imagine une photo très haute et une description de trois paragraphes. Sur un petit téléphone, tout ne rentrerait pas. Le SingleChildScrollView est la solution simple et efficace : il agit comme une "pellicule de film" que l'utilisateur peut faire défiler si le contenu dépasse. C'est une bonne pratique pour s'assurer que l'interface est robuste et ne "casse" jamais à cause d'un contenu trop grand.

// En résumé, EcranDetail est un composant de visualisation spécialisé et isolé. Il sait faire une seule chose, mais il la fait bien : prendre un objet Photo et le présenter joliment à l'utilisateur.

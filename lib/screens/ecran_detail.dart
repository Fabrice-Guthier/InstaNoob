// Imports nécessaires pour afficher l'image mise en cache, les widgets de base et connaître la structure d'une 'Photo'.
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:likeit/models/photo.dart';
import 'package:likeit/providers/app_state.dart';
import 'package:provider/provider.dart';

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
    return GestureDetector(
      onTap: () {
        Navigator.pop(context); 
        // On permet à l'utilisateur de revenir en arrière en tapotant n'importe où sur l'écran.
        // C'est comme un bouton "Retour" invisible, mais qui fonctionne partout.
      },
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: photo.id,
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
            Positioned(
              bottom: 70, // Ajuste cette valeur pour éviter de chevaucher le bouton favori
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      photo.auteur,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Consumer<AppState>(
                  builder: (context, appState, child) {
                    final estFavori = appState.estFavori(photo);
                    return IconButton(
                      iconSize: 32,
                      icon: Icon(
                        estFavori ? Icons.favorite : Icons.favorite_border,
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
            ),
          ],
        ),
      ),
    );
  }
}

// Cet écran a une seule et unique mission : afficher en grand les détails d'une seule photo. C'est la loupe de l'application.

// On peut imaginer que c'est comme un "zoom" sur une photo.
// Quand l'utilisateur clique sur une photo dans la liste, il est transporté ici pour voir la photo en grand, avec un bouton pour l'ajouter ou la retirer de ses favoris.

// Le widget utilise un 'GestureDetector' pour permettre à l'utilisateur de revenir en arrière en tapotant n'importe où sur l'écran. C'est une interaction simple et intuitive.
// Le 'Hero' permet une transition fluide entre la photo dans la liste et la photo en détail, créant une expérience utilisateur agréable.
// Le 'Consumer' écoute les changements dans l'état de l'application (AppState) pour savoir si la photo est favorite ou non.
// Le bouton "like" est positionné en bas à droite de l'écran, avec une icône qui change en fonction de l'état de la photo (favori ou non).
// C'est un exemple parfait de la réutilisation des composants et de la séparation des préoccupations.
// En résumé, EcranDetail est un écran simple mais efficace qui met en valeur une photo et permet à l'utilisateur d'interagir avec elle. C'est un bon exemple de la façon dont Flutter facilite la création d'interfaces utilisateur réactives et fluides.

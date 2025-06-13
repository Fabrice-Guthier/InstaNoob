import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:likeit/models/photo.dart';

class EcranDetail extends StatelessWidget {
  const EcranDetail({super.key});

  @override
  Widget build(BuildContext context) {
    // Récupération de la photo passée en argument
    final photo = ModalRoute.of(context)!.settings.arguments as Photo;

    return Scaffold(
      appBar: AppBar(title: Text(photo.auteur)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(imageUrl: photo.url),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(photo.description),
            ),
          ],
        ),
      ),
    );
  }
}

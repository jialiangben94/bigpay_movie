import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../model/movie_model.dart';

class MovieCard extends StatelessWidget {
  final MovieModel model;
  const MovieCard({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 0,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: CachedNetworkImage(
          memCacheWidth: (MediaQuery.of(context).size.width ~/ 3) + 30,
          imageUrl: 'https://image.tmdb.org/t/p/w500${model.posterPath}',
          placeholder: (context, url) => Container(
              color: Colors.white,
              child: const Center(child: CircularProgressIndicator())),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:tv_app/features/series/domain/entities/series.dart';

class SerieDetailPage extends StatelessWidget {
  final Series serie;

  const SerieDetailPage({super.key, required this.serie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(serie.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (serie.imageUrl != null)
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(serie.imageUrl!),
                ),
              ),
            const SizedBox(height: 16),
            Text(
              serie.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            if (serie.genres.isNotEmpty)
              Text(
                "Genres: ${serie.genres.join(', ')}",
                style:
                    const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
            const SizedBox(height: 10),
            if (serie.summary != null)
              Text(
                serie.summary!.replaceAll(RegExp(r'<[^>]*>'), ''),
                style: const TextStyle(fontSize: 14),
              ),
          ],
        ),
      ),
    );
  }
}

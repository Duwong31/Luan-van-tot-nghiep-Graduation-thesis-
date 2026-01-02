import 'package:Celes/data/models/movie_model.dart';
import 'package:Celes/l10n/app_localizations.dart';
import 'package:Celes/ui/components/movie_card.dart';
import 'package:Celes/ui/screens/movie_detail/movie_detail_screen.dart';
import 'package:Celes/ui/theme/theme.dart';
import 'package:Celes/utils/app_icon.dart';
import 'package:Celes/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MovieListScreen extends StatelessWidget {
  final String title;
  final List<Movie> movies;

  const MovieListScreen({
    super.key,
    required this.title,
    required this.movies,
  });

  static Route route(RouteSettings routeSettings) {
    final args = routeSettings.arguments as Map<String, dynamic>;
    return MaterialPageRoute(
      builder: (_) => MovieListScreen(
        title: args['title'] as String,
        movies: args['movies'] as List<Movie>,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.primaryColor,
      appBar: AppBar(
        backgroundColor: context.color.primaryColor,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: IconButton(
            icon: SvgPicture.asset(
              AppIcons.arrow_left,
              width: 32,
              height: 32,
              colorFilter: ColorFilter.mode(
                context.color.textDefaultColor,
                BlendMode.srcIn,
              ),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: context.color.textDefaultColor,
          ),
        ),
        centerTitle: true,
      ),
      body: movies.isEmpty
          ? _buildEmptyState(context)
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.48,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 20,
                ),
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  return MovieCard(
                    imageUrl: movie.posterUrl ?? '',
                    title: movie.title,
                    duration: movie.formattedDuration,
                    genres: movie.genre,
                    releaseDate: _formatReleaseDate(movie.releaseDate),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MovieDetailScreen(movie: movie),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.movie_outlined,
            size: 64,
            color: context.color.descriptionColor,
          ),
          const SizedBox(height: 16),
          Text(
            Tr.of(context)!.noMoviesAvailable,
            style: TextStyle(
              color: context.color.descriptionColor,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  String? _formatReleaseDate(String? dateString) {
    if (dateString == null) return null;
    try {
      final date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}

import 'package:Celes/data/models/movie_model.dart';
import 'package:Celes/ui/components/movie_card.dart';
import 'package:Celes/ui/components/see_all_button.dart';
import 'package:Celes/ui/theme/theme.dart';
import 'package:Celes/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CategoryHome extends StatelessWidget {
  final String title;
  final List<Movie> movies;
  final VoidCallback? onSeeAllTap;

  const CategoryHome({
    super.key,
    required this.title,
    required this.movies,
    this.onSeeAllTap,
  });

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: context.color.textDefaultColor,
                ),
              ),
              SeeAllButton(
                onTap: onSeeAllTap,
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Movie cards carousel
        SizedBox(
          height: 340,
          child: CarouselSlider.builder(
            itemCount: movies.length,
            options: CarouselOptions(
              height: 340,
              viewportFraction: 0.45,
              enableInfiniteScroll: false,
              autoPlay: false,
              enlargeCenterPage: false,
              disableCenter: true,
              padEnds: false,
            ),
            itemBuilder: (context, index, realIndex) {
              final movie = movies[index];

              return Container(
                margin: EdgeInsets.only(
                  left: index == 0 ? 16 : 8,
                  right: index == movies.length - 1 ? 16 : 8,
                ),
                child: MovieCard(
                  imageUrl: movie.posterUrl ?? '',
                  title: movie.title,
                  genres: movie.genre ?? movie.genres?.join(', '),
                  releaseDate: movie.releaseDate,
                  width: double.infinity,
                  onTap: () {
                    Navigator.pushNamed(context, '/movieDetail',
                        arguments: movie);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

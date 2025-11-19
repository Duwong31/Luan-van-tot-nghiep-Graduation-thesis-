import 'package:Celes/ui/components/movie_card.dart';
import 'package:Celes/ui/components/see_all_button.dart';
import 'package:Celes/ui/theme/theme.dart';
import 'package:Celes/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CategoryHome extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> movies;
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
          height: 320, // Height for card + info
          child: CarouselSlider.builder(
            itemCount: movies.length,
            options: CarouselOptions(
              height: 320,
              viewportFraction: 0.45, // Show ~2.2 cards
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
                  imageUrl: movie['image'] ?? '',
                  title: movie['title'] ?? '',
                  genres: movie['genres'],
                  releaseDate: movie['releaseDate'],
                  width: double.infinity,
                  height: 220, // Poster height
                  onTap: () {

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

// Extension method để tạo data mẫu
extension CategoryHomeData on CategoryHome {
  static CategoryHome comingSoon({VoidCallback? onSeeAllTap}) {
    final List<Map<String, dynamic>> comingSoonMovies = [
      {
        'title': 'Avatar 2: The Way Of Water',
        'genres': 'Adventure, Sci-fi',
        'releaseDate': '20.12.2022',
        'image': 'https://image.tmdb.org/t/p/w500/t6HIqrRAclMCA60NsSmeqe9RmNV.jpg',
      },
      {
        'title': 'Ant Man Wasp: Quantumania',
        'genres': 'Adventure, Sci-fi',
        'releaseDate': '15.02.2023',
        'image': 'https://image.tmdb.org/t/p/w500/ngl2FKBlU4fhbdsrtdom9LVLBXw.jpg',
      },
      {
        'title': 'Fox In: The Henhouse',
        'genres': 'Adventure',
        'releaseDate': '08.03.2023',
        'image': 'https://image.tmdb.org/t/p/w500/8Vt6mWEReuy4Of61Lnj5Xj704m8.jpg',
      },
      {
        'title': 'John Wick: Chapter 4',
        'genres': 'Action, Thriller',
        'releaseDate': '24.03.2023',
        'image': 'https://image.tmdb.org/t/p/w500/vZloFAK7NmvMGKE7VkF5UHaz0I.jpg',
      },
      {
        'title': 'Fast X',
        'genres': 'Action, Adventure',
        'releaseDate': '19.05.2023',
        'image': 'https://image.tmdb.org/t/p/w500/fiVW06jE7z9YnO4trhaMEdclSiC.jpg',
      },
    ];

    return CategoryHome(
      title: 'Coming soon',
      movies: comingSoonMovies,
      onSeeAllTap: onSeeAllTap,
    );
  }
  
  static CategoryHome popular({VoidCallback? onSeeAllTap}) {
    final List<Map<String, dynamic>> popularMovies = [
      {
        'title': 'Top Gun: Maverick',
        'genres': 'Action, Drama',
        'releaseDate': '27.05.2022',
        'image': 'https://image.tmdb.org/t/p/w500/62HCnUTziyWcpDaBO2i1DX17ljH.jpg',
      },
      {
        'title': 'Minions: The Rise of Gru',
        'genres': 'Animation, Comedy',
        'releaseDate': '01.07.2022',
        'image': 'https://image.tmdb.org/t/p/w500/wKiOkZTN9lUUUNZLmtnwubZYONg.jpg',
      },
      {
        'title': 'Elvis',
        'genres': 'Biography, Drama',
        'releaseDate': '24.06.2022',
        'image': 'https://www.themoviedb.org/t/p/w600_and_h900_bestv2/o76PioEyp6XLLnqJUQpt0VLd2nC.jpg',
      },
    ];

    return CategoryHome(
      title: 'Popular movies',
      movies: popularMovies,
      onSeeAllTap: onSeeAllTap,
    );
  }
}
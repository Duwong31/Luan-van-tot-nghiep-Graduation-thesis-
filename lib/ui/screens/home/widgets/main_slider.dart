import 'package:Celes/ui/components/see_all_button.dart';
import 'package:Celes/ui/theme/theme.dart';
import 'package:Celes/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
class MainSlider extends StatefulWidget {
  const MainSlider({super.key});

  @override
  State<MainSlider> createState() => _MainSliderState();
}

class _MainSliderState extends State<MainSlider> {
  int _currentIndex = 0;

  // Hardcode 6 movies data
  final List<Map<String, dynamic>> movies = [
    {
      'title': 'Avengers - Infinity War',
      'duration': '2h29m',
      'genres': 'Action, adventure, sci-fi',
      'rating': 4.8,
      'ratingCount': '1,222',
      'image': 'https://image.tmdb.org/t/p/w500/7WsyChQLEftFiDOVTGkv3hFpyyt.jpg',
    },
    {
      'title': 'Spider-Man: No Way Home',
      'duration': '2h28m',
      'genres': 'Action, adventure, sci-fi',
      'rating': 4.7,
      'ratingCount': '2,156',
      'image': 'https://image.tmdb.org/t/p/w500/1g0dhYtq4irTY1GPXvft6k4YLjm.jpg',
    },
    {
      'title': 'Black Panther',
      'duration': '2h14m',
      'genres': 'Action, adventure, sci-fi',
      'rating': 4.6,
      'ratingCount': '3,890',
      'image': 'https://image.tmdb.org/t/p/w500/uxzzxijgPIY7slzFvMotPv8wjKA.jpg',
    },
    {
      'title': 'Doctor Strange',
      'duration': '1h55m',
      'genres': 'Action, adventure, fantasy',
      'rating': 4.5,
      'ratingCount': '1,567',
      'image': 'https://www.themoviedb.org/t/p/w600_and_h900_bestv2/rkklqyyUzYrJoo3iDYiTjGbhbaw.jpg',
    },
    {
      'title': 'Thor: Ragnarok',
      'duration': '2h10m',
      'genres': 'Action, adventure, comedy',
      'rating': 4.4,
      'ratingCount': '2,234',
      'image': 'https://image.tmdb.org/t/p/w500/rzRwTcFvttcN1ZpX2xv4j3tSdJu.jpg',
    },
    {
      'title': 'Captain America: Civil War',
      'duration': '2h27m',
      'genres': 'Action, adventure, sci-fi',
      'rating': 4.3,
      'ratingCount': '1,890',
      'image': 'https://image.tmdb.org/t/p/w500/rAGiXaUfPzY7CDEyNKUofk3Kw2e.jpg',
    },
  ];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Now playing',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: context.color.textDefaultColor,
                ),
              ),
              SeeAllButton(
                onTap: () {
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Movie slider (posters only)
        CarouselSlider(
          options: CarouselOptions(
            height: 350,
            viewportFraction: 0.7,
            enableInfiniteScroll: true,
            autoPlay: false,
            enlargeCenterPage: true,
            enlargeFactor: 0.2,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items: movies.map((movie) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      movie['image'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.movie,
                            size: 50,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
        
        const SizedBox(height: 20),
        
        // Movie info for active movie only
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                movies[_currentIndex]['title'],
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: context.color.textDefaultColor,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                '${movies[_currentIndex]['duration']} • ${movies[_currentIndex]['genres']}',
                style: TextStyle(
                  fontSize: 14,
                  color: context.color.textDefaultColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.star,
                    size: 18,
                    color: Colors.amber,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${movies[_currentIndex]['rating']} (${movies[_currentIndex]['ratingCount']})',
                    style: TextStyle(
                      fontSize: 14,
                      color: context.color.textDefaultColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        SizedBox(height: 20),
        // Page indicator
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 160.0),
          child: BarPageIndicator(
            count: movies.length,
            currentIndex: _currentIndex,
          ),
        ),
      ],
    );
  }
}

class BarPageIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;

  const BarPageIndicator({
    super.key,
    required this.count,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 10,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final trackWidth = constraints.maxWidth;
          final thumbWidth = trackWidth / count;
          final left = thumbWidth * currentIndex;

          return Stack(
            children: [
              Container(
                width: trackWidth,
                decoration: BoxDecoration(
                  color: const Color(0xFF333333),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                left: left,
                top: 0,
                bottom: 0,
                child: Container(
                  width: thumbWidth,
                  decoration: BoxDecoration(
                    color: context.color.territoryColor, 
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

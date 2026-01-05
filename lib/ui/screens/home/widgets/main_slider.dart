import 'package:Celes/data/models/movie_model.dart';
import 'package:Celes/l10n/app_localizations.dart';
import 'package:Celes/ui/components/see_all_button.dart';
import 'package:Celes/ui/theme/theme.dart';
import 'package:Celes/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class MainSlider extends StatefulWidget {
  final List<Movie> movies;
  final VoidCallback? onSeeAllTap;

  const MainSlider({
    super.key,
    required this.movies,
    this.onSeeAllTap,
  });

  @override
  State<MainSlider> createState() => _MainSliderState();
}

class _MainSliderState extends State<MainSlider> {
  int _currentIndex = 0;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.movies.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Tr.of(context)!.nowShowing,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: context.color.textDefaultColor,
                ),
              ),
              SeeAllButton(
                onTap: widget.onSeeAllTap,
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
            enableInfiniteScroll: widget.movies.length > 1,
            autoPlay: false,
            enlargeCenterPage: true,
            enlargeFactor: 0.2,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items: widget.movies.map((movie) {
            return Builder(
              builder: (BuildContext context) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/movieDetail',
                        arguments: movie);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        movie.posterUrl ?? '',
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
                  ),
                );
              },
            );
          }).toList(),
        ),

        const SizedBox(height: 20),
        if (_currentIndex < widget.movies.length)
          SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.movies[_currentIndex].title,
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
                  _buildMovieInfo(widget.movies[_currentIndex]),
                  style: TextStyle(
                    fontSize: 14,
                    color: context.color.textDefaultColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

        const SizedBox(height: 20),
        // Page indicator
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 160.0),
          child: BarPageIndicator(
            count: widget.movies.length,
            currentIndex: _currentIndex,
          ),
        ),
      ],
    );
  }

  String _buildMovieInfo(Movie movie) {
    List<String> parts = [];
    if (movie.formattedDuration.isNotEmpty) {
      parts.add(movie.formattedDuration);
    }
    if (movie.genre != null && movie.genre!.isNotEmpty) {
      parts.add(movie.genre!);
    } else if (movie.genres != null && movie.genres!.isNotEmpty) {
      parts.add(movie.genres!.join(', '));
    }
    return parts.join(' • ');
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
    if (count == 0) return const SizedBox.shrink();

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

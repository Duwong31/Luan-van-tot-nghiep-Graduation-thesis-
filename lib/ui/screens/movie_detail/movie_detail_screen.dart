import 'package:Celes/ui/components/avatar_card.dart';
import 'package:Celes/ui/screens/select_seat/select_datetime_screen.dart';
import 'package:Celes/ui/theme/theme.dart';
import 'package:Celes/utils/app_icon.dart';
import 'package:Celes/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MovieDetailScreen extends StatefulWidget {
  const MovieDetailScreen({super.key});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();

  static Route route(RouteSettings routeSettings) {
    return MaterialPageRoute(
      builder: (_) => const MovieDetailScreen(),
    );
  }
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  bool _isStorylineExpanded = false;

  @override
  Widget build(BuildContext context) {
    final movie = {
      'title': 'Avengers: Infinity War',
      'imageUrl':
          'https://image.tmdb.org/t/p/w500/7WsyChQLEftFiDOVTGkv3hFpyyt.jpg',
      'rating': 4.8,
      'ratingCount': '1,327',
      'duration': '2h 29m',
      'genres': 'Action, adventure, sci-fi',
      'censorship': '13+',
      'language': 'English',
    };

    const double cardOverlap = 120;

    return Scaffold(
      backgroundColor: context.color.primaryColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Poster + gradient
                AspectRatio(
                  aspectRatio: 17 / 10,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(movie['imageUrl'] as String? ?? ''),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                Positioned(
                    top: 16,
                    left: 16,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: context.color.backgroundColor
                              .withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: SvgPicture.asset(
                          AppIcons.arrow_left,
                          width: 32,
                          height: 32,
                          colorFilter: ColorFilter.mode(
                            context.color.textDefaultColor,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    )),

                Positioned(
                  left: 16,
                  right: 16,
                  bottom: -cardOverlap,
                  child: _buildMovieHeaderCard(context, movie),
                ),
              ],
            ),
            const SizedBox(height: cardOverlap + 16),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMovieInfoSection(context, movie),
                  const SizedBox(height: 24),

                  // Storyline
                  Text(
                    'Storyline',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: context.color.textDefaultColor,
                        height: 1.2),
                  ),
                  const SizedBox(height: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getMovieStoryline(movie['title'] as String?),
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.6,
                          color: context.color.textDefaultColor,
                        ),
                        maxLines: _isStorylineExpanded ? null : 4,
                        overflow: _isStorylineExpanded
                            ? TextOverflow.visible
                            : TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isStorylineExpanded = !_isStorylineExpanded;
                          });
                        },
                        child: Text(
                          _isStorylineExpanded ? 'See less' : 'See more',
                          style: TextStyle(
                            fontSize: 16,
                            color: context.color.territoryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Director section
                  Text(
                    'Director',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      height: 1.25,
                      color: context.color.textDefaultColor,
                    ),
                  ),

                  const SizedBox(height: 16),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _getDirectors((movie['title'] as String?))
                          .map((director) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: PersonChip(
                            firstName: director['firstName'] ?? '',
                            lastName: director['lastName'] ?? '',
                            imageUrl: director['imageUrl'] ?? '',
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Actor section
                  Text(
                    'Actor',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      height: 1.25,
                      color: context.color.textDefaultColor,
                    ),
                  ),

                  const SizedBox(height: 16),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children:
                          _getActors((movie['title'] as String?)).map((actor) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: PersonChip(
                            firstName: actor['firstName'] ?? '',
                            lastName: actor['lastName'] ?? '',
                            imageUrl: actor['imageUrl'] ?? '',
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Continue button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SelectDateTimeScreen(
                              movieTitle: movie['title']?.toString() ?? 'Movie',
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.color.territoryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xffF2F2F2),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieInfoSection(
    BuildContext context,
    Map<String, dynamic> movie,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow(
          label: 'Movie genre:',
          value: movie['genres'] as String? ?? 'Unknown',
        ),
        const SizedBox(height: 16),
        _buildInfoRow(
          label: 'Censorship:',
          value: movie['censorship'] as String? ?? '13+',
        ),
        const SizedBox(height: 16),
        _buildInfoRow(
          label: 'Language:',
          value: movie['language'] as String? ?? 'English',
        ),
      ],
    );
  }

  Widget _buildInfoRow({
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: context.color.textDefaultColor,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: context.color.textDefaultColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMovieHeaderCard(
    BuildContext context,
    Map<String, dynamic> movie,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.color.forthColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            (movie['title'] as String?) ?? 'Unknown Movie',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: context.color.textDefaultColor,
                height: 1.2),
          ),
          const SizedBox(height: 6),
          Text(
            '${movie['duration']} • 16.12.2022',
            style: TextStyle(
              fontSize: 16,
              color: context.color.descriptionColor,
            ),
          ),
          const SizedBox(height: 40),
          Row(
            children: [
              Text(
                'Review',
                style: TextStyle(
                    fontSize: 16,
                    color: context.color.textDefaultColor,
                    height: 1.2),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.star, color: Color(0xffFCC434), size: 16),
              const SizedBox(width: 4),
              Text(
                '${movie['rating']}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: context.color.textDefaultColor,
                ),
              ),
              if (movie['ratingCount'] != null) ...[
                const SizedBox(width: 4),
                Text(
                  '(${movie['ratingCount']})',
                  style: TextStyle(
                    fontSize: 12,
                    color: context.color.descriptionColor,
                  ),
                ),
              ],
            ],
          ),
          Row(
            children: [
              Row(
                children: List.generate(
                  5,
                  (index) => Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Icon(
                      Icons.star,
                      size: 32,
                      color: Color(0xff575757),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: context.color.descriptionColor,
                  side: BorderSide(color: context.color.descriptionColor),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                onPressed: () {},
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(AppIcons.play, width: 16, height: 16),
                    SizedBox(width: 4),
                    const Text(
                      'Watch trailer',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getMovieStoryline(String? title) {
    return 'As the Avengers and their allies have continued to protect the world from threats too large for any one hero to handle, a new danger has emerged from the cosmic shadows: Thanos. A despot of intergalactic infamy, his goal is to collect all six Infinity Stones, artifacts of unimaginable power, and use them to inflict his twisted will on all of reality. Everything the Avengers have fought for has led up to this moment - the fate of Earth and existence itself has never been more uncertain. The heroes must be willing to sacrifice everything in an attempt to defeat the powerful Thanos before his blitz of devastation and ruin puts an end to the universe.';
  }

  List<Map<String, String>> _getDirectors(String? title) {
    return [
      {
        'firstName': 'Anthony',
        'lastName': 'Russo',
        'imageUrl':
            'https://image.tmdb.org/t/p/w200/bKqrshBbUAS6TAetMjdPZAbnMPL.jpg',
      },
      {
        'firstName': 'Joe',
        'lastName': 'Russo',
        'imageUrl':
            'https://image.tmdb.org/t/p/w200/mKBWQqLFjWFVn63b9tVsUggmgUW.jpg',
      },
    ];
  }

  List<Map<String, String>> _getActors(String? title) {
    return [
      {
        'firstName': 'Robert',
        'lastName': 'Downey Jr.',
        'imageUrl':
            'https://image.tmdb.org/t/p/w200/5qHNjhtjMD4YWH3UP0rm4tKwxCL.jpg',
      },
      {
        'firstName': 'Chris',
        'lastName': 'Evans',
        'imageUrl':
            'https://image.tmdb.org/t/p/w200/3bOGNsHlrswhyW79uvIHH1V43JI.jpg',
      },
      {
        'firstName': 'Mark',
        'lastName': 'Ruffalo',
        'imageUrl':
            'https://image.tmdb.org/t/p/w200/z3dvKqMNDQWk3QLxzumloQVR0pv.jpg',
      },
      {
        'firstName': 'Chris',
        'lastName': 'Hemsworth',
        'imageUrl':
            'https://image.tmdb.org/t/p/w200/jpurJ9jAcLCYjgHHfYF32m3zJYm.jpg',
      },
    ];
  }
}

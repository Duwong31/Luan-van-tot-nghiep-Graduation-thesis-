import 'package:Celes/ui/components/movie_card.dart';
import 'package:Celes/ui/theme/theme.dart';
import 'package:Celes/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';

class MovieScreen extends StatefulWidget {
  const MovieScreen({super.key});

  @override
  State<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Hardcoded movie data for demonstration
  final List<Map<String, dynamic>> nowPlayingMovies = [
    {
      'imageUrl': 'https://image.tmdb.org/t/p/w500/4q2NNj4S5dG2RLF9CpXsej7yXl.jpg', // Spider-Man: Far From Home
      'title': 'Spider-Man: Far From Home',
      'rating': 4.0,
      'ratingCount': '982',
      'duration': '2 hour 6 minutes',
      'genres': 'Action, Sci-fi',
      'releaseDate': '2023-12-15',
    },
    {
      'imageUrl': 'https://image.tmdb.org/t/p/w500/pFlaoHTZeyNkG83vxsAJiGzfSsa.jpg', // Black Adam
      'title': 'Black Adam',
      'rating': 4.0,
      'ratingCount': '682',
      'duration': '2 hour 19 minutes',
      'genres': 'Action, Sci-fi',
      'releaseDate': '2023-11-20',
    },
    {
      'imageUrl': 'https://image.tmdb.org/t/p/w500/6KErczPBROQty7QoIsaa6wJYXZi.jpg', // Avengers: Infinity War
      'title': 'Avengers: Infinity War',
      'rating': 4.5,
      'ratingCount': '1245',
      'duration': '2 hour 29 minutes',
      'genres': 'Action, Adventure',
      'releaseDate': '2023-10-10',
    },
    {
      'imageUrl': 'https://image.tmdb.org/t/p/w500/r7vmZjiyZw9rpJMQJdXpjgiCOk9.jpg', // Guardians of the Galaxy
      'title': 'Guardians of the Galaxy',
      'rating': 4.2,
      'ratingCount': '897',
      'duration': '2 hour 1 minutes',
      'genres': 'Action, Adventure',
      'releaseDate': '2023-09-25',
    },
  ];

  final List<Map<String, dynamic>> comingSoonMovies = [
    {
      'imageUrl': 'https://image.tmdb.org/t/p/w500/t6HIqrRAclMCA60NsSmeqe9RmNV.jpg', // Avatar 2: The Way Of Water
      'title': 'Avatar 2: The Way Of Water',
      'rating': null,
      'ratingCount': null,
      'duration': null,
      'genres': 'Adventure, Sci-fi',
      'releaseDate': '20.12.2022',
    },
    {
      'imageUrl': 'https://image.tmdb.org/t/p/w500/ngl2FKBlU4fhbdsrtdom9LVLBXw.jpg', // Ant-Man and the Wasp: Quantumania
      'title': 'Ant Man Wasp: Quantumania',
      'rating': null,
      'ratingCount': null,
      'duration': null,
      'genres': 'Adventure, Sci-fi',
      'releaseDate': '15.02.2023',
    },
    {
      'imageUrl': 'https://image.tmdb.org/t/p/w500/5M0j0B18abtBI5gi2RhfjjurTqb.jpg', // Shazam! Fury of the Gods
      'title': 'Shazam!: Fury of the Gods',
      'rating': null,
      'ratingCount': null,
      'duration': null,
      'genres': 'Action, Adventure',
      'releaseDate': '17.03.2023',
    },
    {
      'imageUrl': 'https://image.tmdb.org/t/p/w500/vgpXmVaVyUL7GGiDeiK1mKEKzcX.jpg', // Puss in Boots: The Last Wish
      'title': 'Puss in Boots: The Last Wish',
      'rating': null,
      'ratingCount': null,
      'duration': null,
      'genres': 'Animation, Adventure',
      'releaseDate': '21.12.2022',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.primaryColor,
      appBar: AppBar(
        backgroundColor: context.color.primaryColor,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false, 
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(20),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              decoration: BoxDecoration(
                color: context.color.forthColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: context.color.territoryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: Colors.white,
                unselectedLabelColor: context.color.textDefaultColor,
                labelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                tabs: [
                  Tab(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: const Text('Now playing'),
                    ),
                  ),
                  Tab(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: const Text('Coming soon'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMovieGrid(nowPlayingMovies),
          _buildMovieGrid(comingSoonMovies),
        ],
      ),
    );
  }

  Widget _buildMovieGrid(List<Map<String, dynamic>> movies) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Expanded(
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
              imageUrl: movie['imageUrl'],
              title: movie['title'],
              rating: movie['rating'],
              ratingCount: movie['ratingCount'],
              duration: movie['duration'],
              genres: movie['genres'],
              releaseDate: movie['releaseDate'],
              onTap: () {
                // Navigate to movie detail screen
                print('Tapped on movie: ${movie['title']}');
              },
            );
          },
        ),
      ),
    );
  }
}
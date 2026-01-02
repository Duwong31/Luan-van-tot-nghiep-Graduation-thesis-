import 'package:Celes/data/cubits/home/home_cubit.dart';
import 'package:Celes/data/models/movie_model.dart';
import 'package:Celes/l10n/app_localizations.dart';
import 'package:Celes/ui/components/movie_card.dart';
import 'package:Celes/ui/screens/movie_detail/movie_detail_screen.dart';
import 'package:Celes/ui/theme/theme.dart';
import 'package:Celes/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    // Fetch home data if not already loaded
    final homeState = context.read<HomeCubit>().state;
    if (homeState is! HomeLoaded) {
      context.read<HomeCubit>().fetchHomeData();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      child: Text(Tr.of(context)!.nowShowing),
                    ),
                  ),
                  Tab(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      child: Text(Tr.of(context)!.comingSoon),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return _buildLoadingView();
          } else if (state is HomeLoaded) {
            return TabBarView(
              controller: _tabController,
              children: [
                _buildMovieGrid(state.homeData.nowShowing),
                _buildMovieGrid(state.homeData.comingSoon),
              ],
            );
          } else if (state is HomeError) {
            return _buildErrorView(state.errorMessage);
          }
          return _buildLoadingView();
        },
      ),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: CircularProgressIndicator(
        color: context.color.territoryColor,
      ),
    );
  }

  Widget _buildErrorView(String errorMessage) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[400],
            ),
            const SizedBox(height: 16),
            Text(
              Tr.of(context)!.error,
              style: TextStyle(
                color: context.color.textDefaultColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage,
              style: TextStyle(
                color: context.color.descriptionColor,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.read<HomeCubit>().fetchHomeData();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: context.color.territoryColor,
              ),
              child: Text(Tr.of(context)!.retry),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieGrid(List<Movie> movies) {
    if (movies.isEmpty) {
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

    return Padding(
      padding: const EdgeInsets.all(16),
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
            rating: null, // API doesn't provide rating in list
            ratingCount: null,
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

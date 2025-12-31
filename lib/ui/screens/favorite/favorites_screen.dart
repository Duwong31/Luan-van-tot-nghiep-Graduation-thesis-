import 'package:Celes/data/cubits/favorite/favorite_cubit.dart';
import 'package:Celes/l10n/app_localizations.dart';
import 'package:Celes/ui/components/movie_card.dart';
import 'package:Celes/ui/theme/theme.dart';
import 'package:Celes/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      builder: (_) => const FavoritesScreen(),
    );
  }

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<FavoriteCubit>().fetchFavorites();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      final state = context.read<FavoriteCubit>().state;
      if (state is FavoriteLoaded && state.hasMore) {
        context
            .read<FavoriteCubit>()
            .fetchFavorites(page: state.currentPage + 1, loadMore: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.backgroundColor,
      appBar: AppBar(
        backgroundColor: context.color.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: context.color.textColorDark,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          Tr.of(context)!.favorites,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: context.color.textColorDark,
          ),
        ),
      ),
      body: BlocConsumer<FavoriteCubit, FavoriteState>(
        listener: (context, state) {
          if (state is FavoriteActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
          } else if (state is FavoriteActionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is FavoriteLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is FavoriteError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: context.color.textColorDark.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: TextStyle(
                      color: context.color.textColorDark.withValues(alpha: 0.7),
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<FavoriteCubit>().fetchFavorites();
                    },
                    child: Text(Tr.of(context)!.retry),
                  ),
                ],
              ),
            );
          }

          if (state is FavoriteLoaded) {
            if (state.movies.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: 64,
                      color: context.color.textColorDark.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      Tr.of(context)!.noFavorites,
                      style: TextStyle(
                        color: context.color.textColorDark.withValues(alpha: 0.7),
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                await context.read<FavoriteCubit>().fetchFavorites();
              },
              child: GridView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.65,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 16,
                ),
                itemCount:
                    state.movies.length + (state.hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= state.movies.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  final movie = state.movies[index];
                  return MovieCard(
                    imageUrl: movie.poster?.url ?? '',
                    title: movie.title,
                    rating: movie.rating,
                    duration: movie.duration?.toString(),
                    genres: movie.genre,
                    releaseDate: movie.releaseDate,
                    onTap: () {
                      // Navigate to movie detail
                      // Navigator.pushNamed(
                      //   context,
                      //   RouteGenerator.movieDetail,
                      //   arguments: movie.id,
                      // );
                    },
                  );
                },
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}

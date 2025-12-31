import 'package:Celes/data/cubits/favorite/favorite_cubit.dart';
import 'package:Celes/data/cubits/movie/movie_detail_cubit.dart';
import 'package:Celes/data/models/movie_detail_model.dart';
import 'package:Celes/data/models/movie_model.dart';
import 'package:Celes/l10n/app_localizations.dart';
import 'package:Celes/ui/components/avatar_card.dart';
import 'package:Celes/ui/screens/movie_detail/widgets/trailer_player_dialog.dart';
import 'package:Celes/ui/screens/select_seat/select_datetime_screen.dart';
import 'package:Celes/ui/theme/theme.dart';
import 'package:Celes/utils/app_icon.dart';
import 'package:Celes/utils/extensions/extensions.dart';
import 'package:Celes/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie? movie;

  const MovieDetailScreen({super.key, this.movie});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();

  static Route route(RouteSettings routeSettings) {
    final movie = routeSettings.arguments as Movie?;
    return MaterialPageRoute(
      builder: (_) => MovieDetailScreen(movie: movie),
    );
  }
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  bool _isStorylineExpanded = false;
  bool _isLoadingFavorite = false;

  @override
  void initState() {
    super.initState();
    // Fetch movie detail when screen loads
    if (widget.movie != null) {
      context.read<MovieDetailCubit>().fetchMovieDetail(widget.movie!.id);
    }
  }

  void _toggleFavorite(MovieDetail movie) async {
    if (_isLoadingFavorite) return;

    setState(() {
      _isLoadingFavorite = true;
    });

    try {
      await context
          .read<FavoriteCubit>()
          .toggleFavorite(movie.id, movie.isFavorited);

      // Refresh movie detail to get updated favorite status
      if (mounted) {
        context.read<MovieDetailCubit>().fetchMovieDetail(movie.id);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(Tr.of(context)!.favoriteActionFailed),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingFavorite = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.primaryColor,
      body: BlocBuilder<MovieDetailCubit, MovieDetailState>(
        builder: (context, state) {
          if (state is MovieDetailLoading) {
            return _buildLoadingState(context);
          } else if (state is MovieDetailLoaded) {
            return _buildLoadedState(context, state.movieDetail);
          } else if (state is MovieDetailError) {
            return _buildErrorState(context, state.errorMessage);
          }
          // Initial state - show loading or basic info from movie
          return _buildLoadingState(context);
        },
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: context.color.territoryColor,
          ),
          const SizedBox(height: 16),
          Text(
            Tr.of(context)!.loadingMovieInfo,
            style: TextStyle(
              color: context.color.textDefaultColor,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String errorMessage) {
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
              Tr.of(context)!.cannotLoadMovieInfo,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: context.color.textDefaultColor,
                    side: BorderSide(color: context.color.descriptionColor),
                  ),
                  child: Text(Tr.of(context)!.back),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    if (widget.movie != null) {
                      context
                          .read<MovieDetailCubit>()
                          .fetchMovieDetail(widget.movie!.id);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.color.territoryColor,
                  ),
                  child: Text(Tr.of(context)!.retry),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadedState(BuildContext context, MovieDetail movie) {
    const double cardOverlap = 120;

    return SingleChildScrollView(
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
                      image: NetworkImage(movie.posterUrl ?? ''),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          context.color.primaryColor.withValues(alpha: 0.8),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Back button
              Positioned(
                top: MediaQuery.of(context).padding.top + 8,
                left: 16,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color:
                          context.color.backgroundColor.withValues(alpha: 0.3),
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
                ),
              ),

              Transform.translate(
                offset: const Offset(0, 130), // cardOverlap
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildMovieHeaderCard(context, movie),
                ),
              ),
            ],
          ),
          const SizedBox(height: cardOverlap - 20),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMovieInfoSection(context, movie),
                const SizedBox(height: 24),

                // Storyline
                if (movie.description != null &&
                    movie.description!.isNotEmpty) ...[
                  Text(
                    Tr.of(context)!.storyline,
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
                        movie.description!,
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
                          _isStorylineExpanded
                              ? Tr.of(context)!.seeLess
                              : Tr.of(context)!.seeMore,
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
                ],

                // Director section
                if (movie.directors.isNotEmpty) ...[
                  Text(
                    Tr.of(context)!.director,
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
                      children: movie.directors.map((director) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: PersonChip(
                            firstName: director.firstName,
                            lastName: director.lastName,
                            imageUrl: director.avatarUrl ?? '',
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],

                // Actor section
                if (movie.actors.isNotEmpty) ...[
                  Text(
                    Tr.of(context)!.cast,
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
                      children: movie.actors.map((actor) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: PersonChip(
                            firstName: actor.firstName,
                            lastName: actor.lastName,
                            imageUrl: actor.avatarUrl ?? '',
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],

                // Continue button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      UiUtils.checkUser(
                        context: context,
                        onNotGuest: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SelectDateTimeScreen(
                                movieTitle: movie.title,
                                movieId: movie.id,
                                movieImage: movie.posterUrl,
                                genres: movie.genre ?? '',
                              ),
                            ),
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.color.territoryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      Tr.of(context)!.continue_,
                      style: const TextStyle(
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
    );
  }

  Widget _buildMovieInfoSection(
    BuildContext context,
    MovieDetail movie,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (movie.genre != null && movie.genre!.isNotEmpty)
          _buildInfoRow(
            label: 'Movie genre:',
            value: movie.genre!,
          ),
        if (movie.genre != null && movie.genre!.isNotEmpty)
          const SizedBox(height: 16),
        if (movie.ageClassification != null &&
            movie.ageClassification!.isNotEmpty)
          _buildInfoRow(
            label: 'Censorship:',
            value: movie.ageClassification!,
          ),
        if (movie.ageClassification != null &&
            movie.ageClassification!.isNotEmpty)
          const SizedBox(height: 16),
        if (movie.language != null && movie.language!.isNotEmpty)
          _buildInfoRow(
            label: 'Language:',
            value: movie.language!,
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
    MovieDetail movie,
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
            movie.title,
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: context.color.textDefaultColor,
                height: 1.2),
          ),
          const SizedBox(height: 6),
          Text(
            _buildSubtitle(movie),
            style: TextStyle(
              fontSize: 16,
              color: context.color.descriptionColor,
            ),
          ),
          const SizedBox(height: 24),
          // Watch Trailer and Favorite buttons
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: movie.hasTrailer
                      ? () {
                          TrailerPlayerDialog.show(
                            context,
                            trailerUrl: movie.trailerUrl!,
                            movieTitle: movie.title,
                          );
                        }
                      : null,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: context.color.textDefaultColor,
                      side: BorderSide(color: context.color.descriptionColor),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: null,
                    // onPressed: movie.hasTrailer
                    //     ? () {
                    //         TrailerPlayerDialog.show(
                    //           context,
                    //           trailerUrl: movie.trailerUrl!,
                    //           movieTitle: movie.title,
                    //         );
                    //       }
                    //     : null,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          AppIcons.play,
                          width: 20,
                          height: 20,
                          colorFilter: ColorFilter.mode(
                            movie.hasTrailer
                                ? context.color.textDefaultColor
                                : context.color.descriptionColor,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          Tr.of(context)!.watchTrailer,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: movie.hasTrailer
                                ? context.color.textDefaultColor
                                : context.color.descriptionColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Favorite button
              BlocListener<FavoriteCubit, FavoriteState>(
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
                child: IconButton(
                  onPressed: _isLoadingFavorite
                      ? null
                      : () => _toggleFavorite(movie),
                  icon: _isLoadingFavorite
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.red),
                          ),
                        )
                      : Icon(
                          movie.isFavorited
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: movie.isFavorited
                              ? Colors.red
                              : context.color.textDefaultColor,
                          size: 24,
                        ),
                  padding: const EdgeInsets.all(12),
                  constraints: const BoxConstraints(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _buildSubtitle(MovieDetail movie) {
    List<String> parts = [];
    if (movie.formattedDuration.isNotEmpty) {
      parts.add(movie.formattedDuration);
    }
    if (movie.releaseDate != null) {
      parts.add(_formatReleaseDate(movie.releaseDate!));
    }
    return parts.join(' • ');
  }

  String _formatReleaseDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}

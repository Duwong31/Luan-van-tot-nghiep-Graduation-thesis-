import 'package:Celes/data/cubits/home/home_cubit.dart';
import 'package:Celes/data/cubits/notification/notification_cubit.dart';
import 'package:Celes/l10n/app_localizations.dart';
import 'package:Celes/ui/screens/home/widgets/category_home.dart';
import 'package:Celes/ui/screens/home/widgets/home_search.dart';
import 'package:Celes/ui/screens/home/widgets/main_slider.dart';
import 'package:Celes/ui/screens/home/widgets/news_home.dart';
import 'package:Celes/ui/theme/theme.dart';
import 'package:Celes/utils/app_icon.dart';
import 'package:Celes/utils/extensions/extensions.dart';
import 'package:Celes/utils/hive_utils.dart';
import 'package:Celes/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:Celes/data/models/movie_model.dart';
import 'package:Celes/data/repositories/movie_repository.dart';
import 'package:Celes/ui/components/movie_card.dart';
import 'package:Celes/ui/screens/movie/movie_list_screen.dart';
import 'package:Celes/ui/screens/news/news_list_screen.dart';
import 'package:Celes/ui/screens/notification/notification_list_screen.dart';
import 'dart:async';

const double sidePadding = 10;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.from});
  final String? from;
  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<HomeScreen> {
  @override
  bool get wantKeepAlive => true;

  late final ScrollController _scrollController = ScrollController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  final MovieRepository _movieRepository = MovieRepository();
  Timer? _debounce;
  bool _isSearching = false;
  List<Movie> _searchResults = [];
  String? _searchErrorMessage;
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    notificationPermissionChecker();
    context.read<HomeCubit>().fetchHomeData();
    if (HiveUtils.isUserAuthenticated()) {
      context.read<NotificationCubit>().fetchNotifications();
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  /// Get display name from Hive
  String _getDisplayName() {
    final fullName = HiveUtils.getUserName();
    if (fullName == null || fullName.isEmpty) {
      return Tr.of(context)!.guest;
    }
    return fullName;
  }

  void addPageScrollListener() {
    //homeScreenController.addListener(pageScrollListener);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leadingWidth: double.maxFinite,
          leading: Padding(
            padding: const EdgeInsets.symmetric(horizontal: sidePadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left side - Greeting
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text(
                            Tr.of(context)!.hi(_getDisplayName()),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: context.color.textDefaultColor,
                            ),
                          ),
                          const Text(
                            '👋',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Right side - Notification icon with badge
                BlocBuilder<NotificationCubit, NotificationState>(
                  builder: (context, notificationState) {
                    int unreadCount = 0;
                    if (notificationState is NotificationLoaded) {
                      unreadCount = notificationState.unreadCount;
                    }

                    return GestureDetector(
                      onTap: HiveUtils.isUserAuthenticated()
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const NotificationListScreen(),
                                ),
                              );
                            }
                          : null, // Disable tap for guest users
                      child: SizedBox(
                        width: 32,
                        height: 32,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            // Bell icon
                            UiUtils.getSvg(
                              AppIcons.notification_dark,
                              fit: BoxFit.none,
                              color: context.color.iconColor,
                            ),
                            // Badge
                            if (unreadCount > 0)
                              Positioned(
                                right: -4,
                                top: -4,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  constraints: const BoxConstraints(
                                    minWidth: 16,
                                    minHeight: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color: context.color.territoryColor,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: context.color.secondaryColor,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      unreadCount > 99 ? '99+' : '$unreadCount',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        backgroundColor: context.color.secondaryColor,
        body: RefreshIndicator(
          triggerMode: RefreshIndicatorTriggerMode.anywhere,
          key: _refreshIndicatorKey,
          color: context.color.territoryColor,
          onRefresh: () async {
            await context.read<HomeCubit>().refreshHomeData();
          },
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              if (state is HomeLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (state is HomeError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: context.color.textDefaultColor
                            .withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        state.errorMessage,
                        style: TextStyle(
                          color: context.color.textDefaultColor
                              .withValues(alpha: 0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.read<HomeCubit>().fetchHomeData();
                        },
                        child: Text(Tr.of(context)!.retry),
                      ),
                    ],
                  ),
                );
              }

              if (state is HomeLoaded) {
                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  controller: _scrollController,
                  padding: const EdgeInsetsDirectional.only(bottom: 30),
                  children: [
                    homeScreenContent(state),
                  ],
                );
              }

              // Initial state - show loading
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget homeScreenContent(HomeLoaded state) {
    final homeData = state.homeData;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        HomeSearchField(onSearchChanged: _onSearchChanged),
        const SizedBox(height: 24),
        if (_searchQuery.isNotEmpty)
          _buildSearchResults()
        else ...[
          MainSlider(
            movies: homeData.nowShowing,
            onSeeAllTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MovieListScreen(
                    title: Tr.of(context)!.nowShowing,
                    movies: homeData.nowShowing,
                  ),
                ),
              );
            },
          ),

          // Coming Soon section
          if (homeData.comingSoon.isNotEmpty) ...[
            const SizedBox(height: 32),
            CategoryHome(
              title: Tr.of(context)!.comingSoon,
              movies: homeData.comingSoon,
              onSeeAllTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MovieListScreen(
                      title: Tr.of(context)!.comingSoon,
                      movies: homeData.comingSoon,
                    ),
                  ),
                );
              },
            ),
          ],

          // Upcoming section
          // if (homeData.upcoming.isNotEmpty) ...[
          //   const SizedBox(height: 32),
          //   CategoryHome(
          //     title: Tr.of(context)!.upcoming,
          //     movies: homeData.upcoming,
          //     onSeeAllTap: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => MovieListScreen(
          //             title: Tr.of(context)!.upcoming,
          //             movies: homeData.upcoming,
          //           ),
          //         ),
          //       );
          //     },
          //   ),
          // ],

          // Movie News section
          if (homeData.news.isNotEmpty) ...[
            NewsHomeCard(
              title: Tr.of(context)!.movieNews,
              news: homeData.news,
              onSeeAllTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewsListScreen(
                      newsList: homeData.news,
                    ),
                  ),
                );
              },
            ),
          ],
        ],
      ],
    );
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });

    if (_debounce?.isActive ?? false) _debounce!.cancel();

    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
        _searchErrorMessage = null;
      });
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      setState(() {
        _isSearching = true;
        _searchErrorMessage = null;
        _searchResults = [];
      });

      try {
        final response = await _movieRepository.searchMovies(query);
        if (response.success && response.data != null) {
          if (mounted) {
            setState(() {
              _searchResults = response.data!;
              _isSearching = false;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              _searchResults = [];
              _isSearching = false;
              _searchErrorMessage = response.message;
            });
          }
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _searchResults = [];
            _isSearching = false;
            _searchErrorMessage = e.toString();
          });
        }
      }
    });
  }

  Widget _buildSearchResults() {
    if (_isSearching) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: CircularProgressIndicator(
            color: context.color.territoryColor,
          ),
        ),
      );
    }

    if (_searchErrorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Text(
            _searchErrorMessage!,
            style: TextStyle(color: context.color.error),
          ),
        ),
      );
    }

    if (_searchResults.isEmpty) {
      return Center(
          child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Text(
          "No movies found",
          style: TextStyle(color: context.color.textDefaultColor),
        ),
      ));
    }

    return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.50,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
        itemCount: _searchResults.length,
        padding: const EdgeInsets.symmetric(horizontal: sidePadding),
        itemBuilder: (ctx, index) {
          final movie = _searchResults[index];
          return Container(
              alignment: Alignment.center,
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
              ));
        });
  }
}

Future<void> notificationPermissionChecker() async {
  if (!(await Permission.notification.isGranted)) {
    await Permission.notification.request();
  }
}

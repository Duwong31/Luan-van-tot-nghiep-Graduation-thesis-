import 'package:Celes/data/cubits/home/home_cubit.dart';
import 'package:Celes/ui/screens/home/widgets/category_home.dart';
import 'package:Celes/ui/screens/home/widgets/home_search.dart';
import 'package:Celes/ui/screens/home/widgets/main_slider.dart';
import 'package:Celes/ui/screens/home/widgets/news_home.dart';
import 'package:Celes/ui/theme/theme.dart';
import 'package:Celes/utils/app_icon.dart';
import 'package:Celes/utils/extensions/extensions.dart';
import 'package:Celes/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

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

  @override
  void initState() {
    super.initState();
    notificationPermissionChecker();
    context.read<HomeCubit>().fetchHomeData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
                            'Hi, Angelina ',
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
                      const SizedBox(height: 2),
                      Text(
                        'Welcome back',
                        style: TextStyle(
                          fontSize: 20,
                          color: context.color.textDefaultColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                // Right side - Profile/Notification icon
                SizedBox(
                  width: 32,
                  height: 32,
                  child: UiUtils.getSvg(
                    AppIcons.notification_dark,
                    fit: BoxFit.none,
                    color: context.color.iconColor,
                  ),
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
                        child: const Text('Retry'),
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
        const HomeSearchField(),
        const SizedBox(height: 24),
        MainSlider(
          movies: homeData.nowShowing,
          onSeeAllTap: () {
            
          },
        ),

        // Coming Soon section
        if (homeData.comingSoon.isNotEmpty) ...[
          const SizedBox(height: 32),
          CategoryHome(
            title: 'Coming Soon',
            movies: homeData.comingSoon,
            onSeeAllTap: () {
            
            },
          ),
        ],

        // Upcoming section
        if (homeData.upcoming.isNotEmpty) ...[
          const SizedBox(height: 32),
          CategoryHome(
            title: 'Upcoming',
            movies: homeData.upcoming,
            onSeeAllTap: () {
              // Navigate to all upcoming movies
            },
          ),
        ],

        // Movie News section
        if (homeData.news.isNotEmpty) ...[
          const SizedBox(height: 32),
          NewsHomeCard(
            title: 'Movie News',
            news: homeData.news,
            onSeeAllTap: () {
              // Navigate to all news
            },
          ),
        ],
      ],
    );
  }
}

Future<void> notificationPermissionChecker() async {
  if (!(await Permission.notification.isGranted)) {
    await Permission.notification.request();
  }
}

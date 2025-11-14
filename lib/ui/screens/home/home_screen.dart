import 'package:Celes/ui/screens/home/widgets/home_search.dart';
import 'package:Celes/ui/theme/theme.dart';
import 'package:Celes/utils/app_icon.dart';
import 'package:Celes/utils/extensions/extensions.dart';
import 'package:Celes/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

const double sidePadding = 10;
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.from});
  final String? from;
  @override
  State<HomeScreen> createState() => HomeScreenState();
}
  
class HomeScreenState extends State<HomeScreen> 
with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<HomeScreen>{
  @override
  bool get wantKeepAlive => true;

  late final ScrollController _scrollController = ScrollController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    notificationPermissionChecker();
  }

  @override
  void dispose() {
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
                              fontSize: 18,
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
                          fontSize: 26,
                          color: context.color.textDefaultColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                // Right side - Profile/Notification icon
                Container(
                  width: 40,
                  height: 40,
                  child: UiUtils.getSvg(
                    AppIcons.notification_dark,
                    fit: BoxFit.none,
                    color: context.color.textDefaultColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        backgroundColor: context.color.primaryColor,
        body: RefreshIndicator(
          triggerMode: RefreshIndicatorTriggerMode.anywhere,
          key: _refreshIndicatorKey,
          color: context.color.territoryColor,
          onRefresh: () async {
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
            controller: _scrollController,
            padding: EdgeInsetsDirectional.only(bottom: 30),
            children: [
              homeScreenContent()
            ],
          ),
        ),
      ),
    );
  }

  Widget homeScreenContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const HomeSearchField(),
      ],
    );
  }
}


Future<void> notificationPermissionChecker() async {
  if (!(await Permission.notification.isGranted)) {
    await Permission.notification.request();
  }
}
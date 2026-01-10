import 'package:Celes/data/models/news_model.dart';
import 'package:Celes/l10n/app_localizations.dart';
import 'package:Celes/ui/components/news_card.dart';
import 'package:Celes/ui/screens/news/news_detail_screen.dart';
import 'package:Celes/ui/theme/theme.dart';
import 'package:Celes/utils/app_icon.dart';
import 'package:Celes/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NewsListScreen extends StatelessWidget {
  final List<News> newsList;

  const NewsListScreen({
    super.key,
    required this.newsList,
  });

  static Route route(RouteSettings routeSettings) {
    final newsList = routeSettings.arguments as List<News>;
    return MaterialPageRoute(
      builder: (_) => NewsListScreen(newsList: newsList),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.primaryColor,
      appBar: AppBar(
        backgroundColor: context.color.primaryColor,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: IconButton(
            icon: SvgPicture.asset(
              AppIcons.arrow_left,
              width: 32,
              height: 32,
              colorFilter: ColorFilter.mode(
                context.color.textDefaultColor,
                BlendMode.srcIn,
              ),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Text(
          Tr.of(context)!.movieNews,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: context.color.textDefaultColor,
          ),
        ),
        centerTitle: true,
      ),
      body: newsList.isEmpty
          ? _buildEmptyState(context)
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: newsList.length,
              itemBuilder: (context, index) {
                final news = newsList[index];
                return NewsCard(
                  news: news,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewsDetailScreen(newsId: news.id),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.article_outlined,
            size: 64,
            color: context.color.descriptionColor,
          ),
          const SizedBox(height: 16),
          Text(
            'No news available',
            style: TextStyle(
              color: context.color.descriptionColor,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

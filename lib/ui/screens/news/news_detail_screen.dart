import 'package:Celes/data/models/news_model.dart';
import 'package:Celes/data/models/news_detail_model.dart';
import 'package:Celes/data/repositories/news_repository.dart';
import 'package:Celes/l10n/app_localizations.dart';
import 'package:Celes/ui/theme/theme.dart';
import 'package:Celes/utils/app_icon.dart';
import 'package:Celes/utils/custom_text.dart';
import 'package:Celes/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:intl/intl.dart';

class NewsDetailScreen extends StatefulWidget {
  final News? news;
  final int? newsId;

  const NewsDetailScreen({
    super.key,
    this.news,
    this.newsId,
  }) : assert(news != null || newsId != null, 
         'Either news or newsId must be provided');

  static Route route(RouteSettings routeSettings) {
    final news = routeSettings.arguments as News;
    return MaterialPageRoute(
      builder: (_) => NewsDetailScreen(news: news),
    );
  }

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  final NewsRepository _newsRepository = NewsRepository();
  bool _isLoading = false;
  NewsDetail? _newsDetail;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // If newsId is provided, fetch news detail from API
    if (widget.newsId != null) {
      _fetchNewsDetail();
    }
  }

  Future<void> _fetchNewsDetail() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _newsRepository.getNewsDetail(widget.newsId!);

      if (response.success && response.data != null) {
        setState(() {
          _newsDetail = response.data;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = response.message;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd/MM/yyyy HH:mm').format(date);
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    // If loading news detail from API
    if (widget.newsId != null && _isLoading) {
      return Scaffold(
        backgroundColor: context.color.primaryColor,
        appBar: AppBar(
          backgroundColor: context.color.primaryColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: context.color.textColorDark),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: CircularProgressIndicator(
            color: context.color.territoryColor,
          ),
        ),
      );
    }

    // If error occurred while loading
    if (widget.newsId != null && _errorMessage != null) {
      return Scaffold(
        backgroundColor: context.color.primaryColor,
        appBar: AppBar(
          backgroundColor: context.color.primaryColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: context.color.textColorDark),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: context.color.textDefaultColor.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 16),
                CustomText(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  color: context.color.textDefaultColor.withValues(alpha: 0.7),
                  fontSize: 16,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _fetchNewsDetail,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.color.territoryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(Tr.of(context)!.retry),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Determine which data to use
    final String title;
    final String? thumbnailUrl;
    final String? authorName;
    final String createdAt;
    final String summary;
    final String content;

    if (widget.newsId != null && _newsDetail != null) {
      // Use NewsDetail from API
      title = _newsDetail!.title;
      thumbnailUrl = _newsDetail!.thumbnail?.url;
      authorName = _newsDetail!.author?.name;
      createdAt = _newsDetail!.createdAt;
      summary = _newsDetail!.summary;
      content = _newsDetail!.content;
    } else if (widget.news != null) {
      // Use News object passed directly
      title = widget.news!.title;
      thumbnailUrl = widget.news!.thumbnail?.url;
      authorName = widget.news!.author?.name;
      createdAt = widget.news!.createdAt;
      summary = widget.news!.summary;
      content = widget.news!.content;
    } else {
      return Scaffold(
        backgroundColor: context.color.primaryColor,
        body: Center(
          child: CustomText(
            'No news data available',
            color: context.color.textDefaultColor,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: context.color.primaryColor,
      body: CustomScrollView(
        slivers: [
          // App Bar with image background
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: context.color.primaryColor,
            leading: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: context.color.backgroundColor.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  icon: SvgPicture.asset(
                    AppIcons.arrow_left,
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(
                      context.color.textDefaultColor,
                      BlendMode.srcIn,
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Image
                  Image.network(
                    thumbnailUrl ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.article,
                          size: 64,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                  // Gradient overlay
                  Container(
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
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: context.color.textDefaultColor,
                      height: 1.3,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Author and date
                  Row(
                    children: [
                      // Author
                      if (authorName != null) ...[
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: context.color.territoryColor,
                          child: Text(
                            authorName[0].toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              authorName,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: context.color.textDefaultColor,
                              ),
                            ),
                            Text(
                              _formatDate(createdAt),
                              style: TextStyle(
                                fontSize: 12,
                                color: context.color.descriptionColor,
                              ),
                            ),
                          ],
                        ),
                      ] else ...[
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: context.color.descriptionColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatDate(createdAt),
                          style: TextStyle(
                            fontSize: 14,
                            color: context.color.descriptionColor,
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Summary
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: context.color.forthColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      summary,
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: context.color.textDefaultColor,
                        height: 1.5,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Content (HTML)
                  HtmlWidget(
                    content,
                    textStyle: TextStyle(
                      fontSize: 16,
                      color: context.color.textDefaultColor,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

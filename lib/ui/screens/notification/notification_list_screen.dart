import 'package:Celes/data/cubits/notification/notification_cubit.dart';
import 'package:Celes/data/models/notification_model.dart';
import 'package:Celes/l10n/app_localizations.dart';
import 'package:Celes/ui/theme/theme.dart';
import 'package:Celes/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({Key? key}) : super(key: key);

  @override
  State<NotificationListScreen> createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch notifications on screen load
    context.read<NotificationCubit>().fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.secondaryColor,
      appBar: AppBar(
        backgroundColor: context.color.secondaryColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.color.textDefaultColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Notifications', // TODO: Add to localization
          style: TextStyle(
            color: context.color.textDefaultColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is NotificationError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48,
                    color:
                        context.color.textDefaultColor.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.errorMessage,
                    style: TextStyle(
                      color:
                          context.color.textDefaultColor.withValues(alpha: 0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<NotificationCubit>().fetchNotifications();
                    },
                    child: Text(Tr.of(context)!.retry),
                  ),
                ],
              ),
            );
          }

          if (state is NotificationLoaded) {
            final notifications = state.notifications;

            if (notifications.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notifications_none,
                      size: 64,
                      color:
                          context.color.textDefaultColor.withValues(alpha: 0.3),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No notifications', // TODO: Add to localization
                      style: TextStyle(
                        color: context.color.textDefaultColor
                            .withValues(alpha: 0.7),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                await context.read<NotificationCubit>().refreshNotifications();
              },
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: notifications.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return _NotificationCard(
                    notification: notification,
                    onTap: () {
                      if (!notification.isRead) {
                        context
                            .read<NotificationCubit>()
                            .markAsReadLocally(notification.id);
                      }
                      _handleNotificationTap(context, notification);
                    },
                    onDismiss: () {
                      context
                          .read<NotificationCubit>()
                          .removeNotificationLocally(notification.id);
                    },
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _handleNotificationTap(
      BuildContext context, NotificationItem notification) {
    // Handle navigation based on notification type and related_type
    switch (notification.type) {
      case 'new_movie':
      case 'movie_premiere':
        if (notification.relatedId != null) {
          // Navigate to movie detail
          // Navigator.pushNamed(context, '/movieDetail', arguments: movieId);
        }
        break;
      case 'booking_paid':
        if (notification.relatedId != null) {
          // Navigate to booking detail
          // Navigator.pushNamed(context, '/myTicket', arguments: bookingId);
        }
        break;
      default:
        // General notification - just mark as read
        break;
    }
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationItem notification;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  const _NotificationCard({
    required this.notification,
    required this.onTap,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('notification_${notification.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      onDismissed: (_) => onDismiss(),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: notification.isRead
                ? context.color.secondaryColor
                : context.color.territoryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: notification.isRead
                  ? context.color.textDefaultColor.withValues(alpha: 0.1)
                  : context.color.territoryColor.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon based on notification type
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color:
                      _getIconColor(notification.type).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getIcon(notification.type),
                  color: _getIconColor(notification.type),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              color: context.color.textDefaultColor,
                              fontSize: 14,
                              fontWeight: notification.isRead
                                  ? FontWeight.w500
                                  : FontWeight.w600,
                            ),
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: context.color.territoryColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.body,
                      style: TextStyle(
                        color: context.color.textDefaultColor
                            .withValues(alpha: 0.7),
                        fontSize: 13,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatRelativeTime(notification.createdAt),
                      style: TextStyle(
                        color: context.color.textDefaultColor
                            .withValues(alpha: 0.5),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIcon(String type) {
    switch (type) {
      case 'new_movie':
        return Icons.movie;
      case 'movie_premiere':
        return Icons.stars;
      case 'booking_paid':
        return Icons.confirmation_number;
      case 'general':
        return Icons.info;
      default:
        return Icons.notifications;
    }
  }

  Color _getIconColor(String type) {
    switch (type) {
      case 'new_movie':
        return Colors.blue;
      case 'movie_premiere':
        return Colors.amber;
      case 'booking_paid':
        return Colors.green;
      case 'general':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String _formatRelativeTime(String createdAt) {
    try {
      final dateTime = DateTime.parse(createdAt);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays > 7) {
        return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
      } else if (difference.inDays > 0) {
        return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return createdAt;
    }
  }
}

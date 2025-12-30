import 'package:Celes/ui/theme/theme.dart';
import 'package:Celes/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';

class DateModel {
  final String day;
  final int date;
  final DateTime fullDate;
  final bool isToday;

  DateModel({
    required this.day,
    required this.date,
    required this.fullDate,
    required this.isToday,
  });

  /// Generate dates for multiple weeks starting from today
  static List<List<DateModel>> generateWeeks({int weekCount = 8}) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    // Find the start of current week (Monday)
    final daysFromMonday = (today.weekday - 1) % 7;
    final startOfWeek = today.subtract(Duration(days: daysFromMonday));

    List<List<DateModel>> weeks = [];

    for (int week = 0; week < weekCount; week++) {
      List<DateModel> weekDates = [];
      for (int day = 0; day < 7; day++) {
        final date = startOfWeek.add(Duration(days: week * 7 + day));
        weekDates.add(DateModel(
          day: weekdays[day],
          date: date.day,
          fullDate: date,
          isToday: date.isAtSameMomentAs(today),
        ));
      }
      weeks.add(weekDates);
    }

    return weeks;
  }

  /// Generate flat list of dates (for backward compatibility)
  static List<DateModel> generateDates({int count = 7}) {
    final weeks = generateWeeks(weekCount: 1);
    return weeks.isNotEmpty ? weeks.first : [];
  }
}

class DateSelector extends StatefulWidget {
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const DateSelector({
    super.key,
    this.selectedDate,
    required this.onDateSelected,
  });

  @override
  State<DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  late PageController _pageController;
  late List<List<DateModel>> _weeks;
  late int _currentWeekIndex;

  @override
  void initState() {
    super.initState();
    _weeks = DateModel.generateWeeks();
    _currentWeekIndex = 0; // Start at current week
    _pageController = PageController(initialPage: _currentWeekIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  bool _isDateSelected(DateModel date) {
    if (widget.selectedDate == null) return date.isToday;
    return date.fullDate.year == widget.selectedDate!.year &&
        date.fullDate.month == widget.selectedDate!.month &&
        date.fullDate.day == widget.selectedDate!.day;
  }

  // Check if date is in the past
  bool _isDateInPast(DateModel date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return date.fullDate.isBefore(today);
  }

  // Format date as dd-mm-yy
  String _formatSelectedDate() {
    final date = widget.selectedDate ?? DateTime.now();
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = (date.year % 100).toString().padLeft(2, '0');
    return '$day-$month-$year';
  }

  @override
  Widget build(BuildContext context) {
    // Fixed weekday labels
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.black,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Selected date display
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.calendar_today,
                  color: context.color.territoryColor,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  _formatSelectedDate(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          // Fixed weekday row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: weekdays.map((day) {
              return SizedBox(
                width: 40,
                child: Text(
                  day,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withAlpha(120),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          // Scrollable date numbers
          SizedBox(
            height: 70, // Height for date circle + Today label
            child: PageView.builder(
              controller: _pageController,
              itemCount: _weeks.length,
              onPageChanged: (index) {
                setState(() {
                  _currentWeekIndex = index;
                });
              },
              itemBuilder: (context, weekIndex) {
                final week = _weeks[weekIndex];
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: week.map((date) {
                    final isSelected = _isDateSelected(date);
                    final isPast = _isDateInPast(date);

                    return _DateCircle(
                      date: date,
                      isSelected: isSelected,
                      isPast: isPast,
                      onTap: isPast
                          ? null
                          : () => widget.onDateSelected(date.fullDate),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DateCircle extends StatelessWidget {
  final DateModel date;
  final bool isSelected;
  final bool isPast;
  final VoidCallback? onTap;

  const _DateCircle({
    required this.date,
    required this.isSelected,
    required this.isPast,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Date number - inside the circle
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isSelected
                  ? context.color.territoryColor
                  : Colors.transparent,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '${date.date}',
              style: TextStyle(
                color: isPast
                    ? Colors.white.withAlpha(60)
                    : isSelected
                        ? Colors.white
                        : Colors.white.withAlpha(120),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // "Today" label
          const SizedBox(height: 6),
          Text(
            date.isToday ? 'Today' : '',
            style: TextStyle(
              color: context.color.territoryColor,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

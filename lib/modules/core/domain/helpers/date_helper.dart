class DateHelper {
  static (DateTime, DateTime) getInitialAndLastCurrentDate(DateTime data) {
    final today = DateTime.now();
    final firstDayOfMonth = DateTime(data.year, data.month, 1);
    final lastDayOfMonth =
        _isCurrentMonth(data) ? today : DateTime(data.year, data.month + 1, 0);

    return (firstDayOfMonth, lastDayOfMonth);
  }

  static bool _isCurrentMonth(DateTime date) {
    final today = DateTime.now();
    return date.year == today.year && date.month == today.month;
  }
}

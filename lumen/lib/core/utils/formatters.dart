String _two(int n) => n.toString().padLeft(2, '0');

/// 30/10/2026
String formatDate(DateTime date) =>
    '${_two(date.day)}/${_two(date.month)}/${date.year}';

/// 30/10/2026 18:42
String formatDateTime(DateTime date) =>
    '${formatDate(date)} ${_two(date.hour)}:${_two(date.minute)}';

/// 0.38 → 38%
String formatPercent(double fraction) => '${(fraction * 100).round()}%';

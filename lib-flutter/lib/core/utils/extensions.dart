import 'package:flutter/material.dart';

/// Extension methods for String
extension StringExtensions on String {
  /// Capitalize first letter
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Capitalize each word
  String get capitalizeWords {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize).join(' ');
  }

  /// Truncate string to specified length
  String truncate(int maxLength, {String suffix = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - suffix.length)}$suffix';
  }

  /// Check if string is a valid Bitcoin address
  bool get isBitcoinAddress {
    // Basic validation for Bitcoin addresses
    final btcRegex = RegExp(
      r'^(bc1|[13])[a-zA-HJ-NP-Z0-9]{25,87}$',
    );
    return btcRegex.hasMatch(this);
  }

  /// Check if string is a valid transaction hash
  bool get isTransactionHash {
    final hashRegex = RegExp(r'^[a-fA-F0-9]{64}$');
    return hashRegex.hasMatch(this);
  }
}

/// Extension methods for numbers
extension NumberExtensions on num {
  /// Format number with commas
  String get formatWithCommas {
    return toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  /// Format as currency (USD)
  String get formatAsCurrency {
    return '\$${toDouble().toStringAsFixed(2).formatWithCommas}';
  }

  /// Format as percentage
  String formatAsPercent({int decimals = 2}) {
    return '${toStringAsFixed(decimals)}%';
  }

  /// Format Bitcoin amount in BTC
  String get formatAsBtc {
    final btcValue = toDouble() / 100000000; // Convert satoshis to BTC
    return '₿$btcValue';
  }

  /// Format Bitcoin amount in satoshis
  String get formatAsSats {
    return '${toInt().formatWithCommas} sats';
  }
}

/// Extension methods for DateTime
extension DateTimeExtensions on DateTime {
  /// Format as relative time (e.g., "2 hours ago")
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'just now';
    }
  }

  /// Format as short date (e.g., "Jan 15")
  String get shortDate {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[month - 1]} $day';
  }

  /// Format as time (e.g., "3:30 PM")
  String get formatTime {
    final hour = this.hour > 12 ? this.hour - 12 : this.hour;
    final minute = this.minute.toString().padLeft(2, '0');
    final period = this.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
}

/// Extension methods for Duration
extension DurationExtensions on Duration {
  /// Format as readable string (e.g., "5m 30s")
  String get formatReadable {
    final parts = <String>[];
    
    if (inHours > 0) {
      parts.add('${inHours}h');
    }
    if (inMinutes.remainder(60) > 0) {
      parts.add('${inMinutes.remainder(60)}m');
    }
    if (inSeconds.remainder(60) > 0 && inHours == 0) {
      parts.add('${inSeconds.remainder(60)}s');
    }
    
    return parts.isEmpty ? '0s' : parts.join(' ');
  }
}

/// Extension methods for Color
extension ColorExtensions on Color {
  /// Lighten color by percentage
  Color lighten([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final lightness = (hsl.lightness + amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }

  /// Darken color by percentage
  Color darken([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final lightness = (hsl.lightness - amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }

  /// Get contrast color (black or white) for text
  Color get contrastColor {
    final luminance = computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}

/// Extension methods for BuildContext
extension ContextExtensions on BuildContext {
  /// Get screen size
  Size get screenSize => MediaQuery.of(this).size;

  /// Get screen width
  double get screenWidth => screenSize.width;

  /// Get screen height
  double get screenHeight => screenSize.height;

  /// Check if device is tablet
  bool get isTablet => screenWidth >= 600;

  /// Check if device is in landscape mode
  bool get isLandscape => screenWidth > screenHeight;

  /// Get theme data
  ThemeData get theme => Theme.of(this);

  /// Get text theme
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Get color scheme
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Show snackbar
  void showSnackBar(String message, {Duration duration = const Duration(seconds: 2)}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
      ),
    );
  }

  /// Hide keyboard
  void hideKeyboard() {
    FocusScope.of(this).unfocus();
  }
}

import 'package:intl/intl.dart';
import 'package:we_work/core/config/app_localization_constants.dart';

/// Rounds a double value to the nearest thousand (1,000) and appends the letter "K" to indicate thousands.
String formatValueToRoundedThousands(double? value) {
  if (value == null) return '0'; // Handle null values gracefully

  if (value >= 1000) {
    final newValue = (value ~/ 1000) * 1000; // Round to nearest thousand
    return '${newValue ~/ 1000}K'; // Convert to thousands and display rounded integer
  } else {
    return value
        .toInt()
        .toString(); // Return integer value for values under 1,000
  }
}

/// Rounds a double value to the nearest thousand (1,000) and appends the letter "K" to indicate thousands,
/// with optional decimal formatting for values between 1,000 (inclusive) and 10,000 (exclusive).
String formatValueToThousands(double? value) {
  if (value == null) return '0'; // Handle null values gracefully

  if (value >= 10000) {
    final newValue = value / 1000.0; // Convert to thousands
// Format with 1 decimal place if needed
    return newValue
        .toStringAsFixed(newValue.truncateToDouble() == newValue ? 0 : 1);
  } else {
    return value
        .toInt()
        .toString(); // Return integer value for values under 1,000
  }
}

// Assuming the existence of a formattedValue constant in AppLocalizationConstants
const String formattedValueK = 'K'; // Constant for the "K" suffix (thousands)

/// Formats the current date in a human-readable format, including day with ordinal suffix (e.g., 1st, 2nd, 3rd), month name in uppercase, and year.
String getFormattedDate() {
  final now = DateTime.now();
  final formattedDate = DateFormat('d').format(now); // Day as a number (1-31)
  final formattedMonth =
      DateFormat('MMMM').format(now).toUpperCase(); // Month name (uppercase)
  final formattedYear = DateFormat('yyyy').format(now); // Year
  final daySuffix = getDayOrdinalSuffix(int.parse(
      formattedDate)); // Ordinal suffix for the day (e.g., ST, ND, RD, TH)

  return '$formattedDate$daySuffix $formattedMonth $formattedYear';
}

/// Determines the appropriate ordinal suffix (ST, ND, RD, TH) for a given day number.
String getDayOrdinalSuffix(int day) {
  if (day >= 11 && day <= 13) {
    return 'TH'; // Special case for 11th, 12th, and 13th
  }
  switch (day % 10) {
    case 1:
      return 'ST';
    case 2:
      return 'ND';
    case 3:
      return 'RD';
    default:
      return 'TH';
  }
}

/// Fetches the full language name for a given language code, using a map from the `AppLocalizationConstants` class.
/// If the language code is not found in the map, returns "Unknown".
String getFullLanguageName(String languageCode) {
  return AppLocalizationConstants.mapOfLanguageConstants[languageCode] ??
      'Unknown';
}

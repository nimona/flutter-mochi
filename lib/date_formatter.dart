import 'package:intl/intl.dart';
import 'package:mochi/app_localizations.dart';

// https://www.flutterclutter.dev/flutter/tutorials/date-format-dynamic-string-depending-on-how-long-ago/2020/229/

class DateFormatter {
  DateFormatter(this.localizations);

  AppLocalizations localizations;

  String getVerboseDateTimeRepresentation(DateTime dateTime) {
    DateTime now = DateTime.now();
    DateTime justNow = now.subtract(Duration(minutes: 1));
    DateTime localDateTime = dateTime.toLocal();

    if (!localDateTime.difference(justNow).isNegative) {
      return localizations.translate('dateFormatter_just_now');
    }

    String roughTimeString = DateFormat('HH:mm').format(dateTime);

    if (localDateTime.day == now.day &&
        localDateTime.month == now.month &&
        localDateTime.year == now.year) {
      final String today = localizations.translate('dateFormatter_today_at');
      return '$today $roughTimeString';
    }

    DateTime yesterday = now.subtract(Duration(days: 1));

    if (localDateTime.day == yesterday.day &&
        localDateTime.month == now.month &&
        localDateTime.year == now.year) {
      final String yesterday =
          localizations.translate('dateFormatter_yesterday_at');
      return '$yesterday $roughTimeString';
    }

    if (now.difference(localDateTime).inDays < 4) {
      String weekday = DateFormat('EEEE', localizations.locale.toLanguageTag())
          .format(localDateTime);
      return '$weekday, $roughTimeString';
    }

    return '${DateFormat('yMd', localizations.locale.toLanguageTag()).format(dateTime)}, $roughTimeString';
  }
}

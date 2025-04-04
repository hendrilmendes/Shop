import 'package:flutter/material.dart';
import 'package:shop/l10n/app_localizations.dart';
import 'package:shop/screens/about/about.dart';

Widget buildAboutSettings(BuildContext context) {
  return ListTile(
    title: Text(AppLocalizations.of(context)!.about),
    subtitle: Text(AppLocalizations.of(context)!.aboutSub),
    leading: const Icon(Icons.info_outline),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AboutPage()),
      );
    },
  );
}

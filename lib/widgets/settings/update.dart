import 'package:flutter/material.dart';
import 'package:shop/l10n/app_localizations.dart';
import 'package:shop/updater/updater.dart';

Widget buildUpdateSettings(BuildContext context) {
  return ListTile(
    title: Text(AppLocalizations.of(context)!.update),
    subtitle: Text(AppLocalizations.of(context)!.updateSub),
    leading: const Icon(Icons.update_outlined),
    onTap: () {
      Updater.checkForUpdates(context);
    },
  );
}

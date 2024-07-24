import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shop/theme/theme.dart';
import 'package:shop/widgets/settings/about.dart';
import 'package:shop/widgets/settings/category.dart';
import 'package:shop/widgets/settings/review.dart';
import 'package:shop/widgets/settings/support.dart';
import 'package:shop/widgets/settings/theme.dart';
import 'package:shop/widgets/settings/update.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
      ),
      body: ListView(
        children: [
          buildCategoryHeader(
              AppLocalizations.of(context)!.interface, Icons.palette_outlined),
          ThemeSettings(themeModel: themeModel),
          buildCategoryHeader(
              AppLocalizations.of(context)!.outhers, Icons.more_horiz_outlined),
          buildUpdateSettings(context),
          buildReviewSettings(context),
          buildSupportSettings(context),
          buildAboutSettings(context),
        ],
      ),
    );
  }
}

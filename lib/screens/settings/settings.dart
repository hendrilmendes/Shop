import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shop/theme/theme.dart';
import 'package:shop/widgets/settings/about.dart';
import 'package:shop/widgets/settings/accounts.dart';
import 'package:shop/widgets/settings/category.dart';
import 'package:shop/widgets/settings/review.dart';
import 'package:shop/widgets/settings/support.dart';
import 'package:shop/widgets/settings/theme.dart';
import 'package:shop/widgets/settings/update.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  static const routeName = '/settings';

  final User? _user = FirebaseAuth.instance.currentUser;

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
              AppLocalizations.of(context)!.accontYou, Icons.account_circle_outlined),
          AccountUser(user: _user),
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

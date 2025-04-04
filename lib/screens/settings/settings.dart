import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop/l10n/app_localizations.dart';
import 'package:shop/theme/theme.dart';
import 'package:shop/widgets/settings/about.dart';
import 'package:shop/widgets/settings/accounts.dart';
import 'package:shop/widgets/settings/category.dart';
import 'package:shop/widgets/settings/review.dart';
import 'package:shop/widgets/settings/support.dart';
import 'package:shop/widgets/settings/theme.dart';
import 'package:shop/widgets/settings/update.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  static const routeName = '/settings';

  final User? _user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.settings,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          buildCategoryHeader(
              AppLocalizations.of(context)!.accontYou, Icons.account_circle_outlined),
          AccountUser(user: _user),
          const SizedBox(height: 8),
          _buildSectionCard(
            context,
            Column(
              children: [
                ThemeSettings(themeModel: themeModel),
              ],
            ),
          ),
          const SizedBox(height: 8),
          _buildSectionCard(
            context,
            Column(
              children: [
                buildUpdateSettings(context),
                buildReviewSettings(context),
                buildSupportSettings(context),
              ],
            ),
          ),
          _buildSectionCard(
            context,
            Column(
              children: [
                buildAboutSettings(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context,
    Widget child,
  ) {
    return Card(
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Theme.of(context).listTileTheme.tileColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          child,
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../theme/theme_extensions.dart';
import 'app_bottom_nav_bar.dart';

class AppScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final AppTab? currentTab;
  final ValueChanged<AppTab>? onTabSelected;
  final bool isScrollable;
  final EdgeInsetsGeometry padding;
  final bool showDivider;

  const AppScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.currentTab,
    this.onTabSelected,
    this.isScrollable = true,
    this.padding = const EdgeInsets.fromLTRB(16, 16, 16, 32),
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    Widget mainContent = body;

    if (isScrollable) {
      mainContent = SingleChildScrollView(
        padding: padding,
        child: body,
      );
    } else {
      mainContent = Padding(
        padding: padding,
        child: body,
      );
    }

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            if (appBar != null) appBar!,
            if (showDivider && appBar != null)
              Divider(height: 1, color: colors.borderSubtle),
            Expanded(child: mainContent),
          ],
        ),
      ),
      bottomNavigationBar: currentTab != null && onTabSelected != null
          ? AppBottomNavBar(
              currentTab: currentTab!,
              onTabSelected: onTabSelected!,
            )
          : null,
    );
  }
}

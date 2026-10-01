import 'package:flutter/material.dart';

import '../constant/app_dimensions.dart';
import '../utils/responsive.dart';


class AppScaffold extends StatelessWidget {
  final Widget child;
  final String? title;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final bool safeArea;

  const AppScaffold({
    required this.child,
    this.title,
    this.actions,
    this.floatingActionButton,
    this.safeArea = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.horizontalPadding(context),
        vertical: AppDimensions.spacing16,
      ),
      child: child,
    );

    return Scaffold(
      appBar: title == null
          ? null
          : AppBar(
              title: Text(title!),
              actions: actions,
            ),
      body: safeArea ? SafeArea(child: content) : content,
      floatingActionButton: floatingActionButton,
    );
  }
}
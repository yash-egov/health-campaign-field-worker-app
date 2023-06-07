import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../router/app_router.dart';
import 'showcase_constants.dart';

class ShowcaseButton extends StatelessWidget {
  const ShowcaseButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        final current = context.router.current.name;
        final paths = _showcasePathsForRoute(current);

        if (paths == null) return;
        if (paths.isEmpty) return;

        ShowCaseWidget.of(context).startShowCase(paths.toList());
      },
      icon: const Icon(Icons.help_outline),
    );
  }

  Iterable<GlobalKey>? _showcasePathsForRoute(String routeName) {
    return switch (routeName) {
      HomeRoute.name => HomeShowcaseData().showcaseData.map((e) => e.key),
      SearchBeneficiaryRoute.name =>
        SearchBeneficiaryShowcaseData().showcaseData.map((e) => e.key),
      _ => null,
    };
  }
}

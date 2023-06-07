import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

class CustomShowcaseWrapper extends StatefulWidget {
  final int showcasePathCount;
  final Widget Function(
    BuildContext context,
    List<GlobalKey> showcaseKeys,
  ) builder;

  const CustomShowcaseWrapper({
    super.key,
    required this.showcasePathCount,
    required this.builder,
  });

  @override
  State<CustomShowcaseWrapper> createState() => _CustomShowcaseWrapperState();
}

class _CustomShowcaseWrapperState extends State<CustomShowcaseWrapper> {
  late final List<GlobalKey> _showcaseKeys;

  @override
  void initState() {
    _showcaseKeys = List.generate(
      widget.showcasePathCount,
      (index) => GlobalKey(debugLabel: 'showcase_${index + 1}'),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _showcaseKeys);
  }
}

class CustomShowcaseWidget extends StatelessWidget {
  final GlobalKey showcaseKey;
  final Widget child;
  final String message;

  const CustomShowcaseWidget({
    super.key,
    required this.showcaseKey,
    required this.child,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Showcase.withWidget(
      key: showcaseKey,
      height: 100,
      width: MediaQuery.of(context).size.width,
      disableMovingAnimation: true,
      overlayOpacity: 0.6,
      targetPadding: const EdgeInsets.all(8),
      container: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      ShowCaseWidget.of(context).dismiss();
                    },
                    child: const Text('Skip'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 2,
                      ),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () {
                      ShowCaseWidget.of(context).next();
                    },
                    child: const Text('Next'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      child: child,
    );
  }
}

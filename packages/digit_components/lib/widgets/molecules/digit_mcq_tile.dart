import 'package:digit_components/digit_components.dart';
import 'package:digit_components/widgets/atoms/digit_divider.dart';
import 'package:flutter/material.dart';

enum Options { yes, no }

class MCQTile extends StatefulWidget {
  final String question;
  final String alert;
  final int index;
  final Function(int, Options?, String?) callback;

  const MCQTile(
      {Key? key,
      required this.question,
      required this.alert,
      required this.index,
      required this.callback,})
      : super(key: key);

  @override
  State<MCQTile> createState() => _MCQTileState();
}

class _MCQTileState extends State<MCQTile> {
  Options? _val = Options.yes;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 16),
          child: Text(
            widget.question,
            style: theme.textTheme.headlineSmall,
          ),
        ),
        Row(
          children: [
            Radio<Options>(
              value: Options.yes,
              groupValue: _val,
              onChanged: onChanged,
            ),
            const Text('Yes'),
          ],
        ),
        Row(
          children: [
            Radio<Options>(
              value: Options.no,
              groupValue: _val,
              onChanged: onChanged,
            ),
            const Text('No'),
          ],
        ),
        Visibility(
          visible: _val == Options.no,
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
            child: Column(
              children: [
                const DigitTextField(label: 'Reason'),
                const SizedBox(
                  height: 16,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: theme.colorScheme.errorContainer,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.warning, color: theme.colorScheme.scrim),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              'Alert',
                              style: theme.textTheme.headlineMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          widget.alert,
                          style: theme.textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        const DigitDivider(),
      ],
    );
  }

  void onChanged(Options? option) {
    setState(() {
      _val = option;
    });

    widget.callback(widget.index, _val, 'hello');
  }
}

import 'package:digit_components/digit_components.dart';
import 'package:flutter/material.dart';
import '../../models/digit_row_card/digit_row_card_model.dart';

class DigitLanguageCard extends StatelessWidget {
  final List<DigitRowCardModel> digitRowCardItems;
  final Function onLanguageChange;
  final VoidCallback onLanguageSubmit;
  final String languageSubmitLabel;

  const DigitLanguageCard({
    super.key,
    required this.digitRowCardItems,
    required this.onLanguageChange,
    required this.onLanguageSubmit,
    required this.languageSubmitLabel,
  });

  @override
  Widget build(BuildContext context) {
    return DigitCard(
      margin: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DigitRowCard(
            onPressed: (data) => onLanguageChange(data),
            list: digitRowCardItems,
            width:
                (MediaQuery.of(context).size.width / digitRowCardItems.length) -
                    16 * digitRowCardItems.length,
          ),
          const SizedBox(
            height: 24,
            width: 0,
          ),
          DigitElevatedButton(
            onPressed: onLanguageSubmit,
            child: Center(
              child: Text(languageSubmitLabel),
            ),
          ),
        ],
      ),
    );
  }
}

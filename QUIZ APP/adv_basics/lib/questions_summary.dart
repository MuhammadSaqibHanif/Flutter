import 'package:flutter/material.dart';

class QuestionsSummary extends StatelessWidget {
  const QuestionsSummary(this.summaryData, {super.key});

  final List<Map<String, Object>> summaryData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: summaryData.map((data) {
        return Row(
          children: [
            Text(((data['question-index'] as int) + 1).toString()),
            Column(
              children: [
                Text(data['question'] as String),
                const SizedBox(height: 5),
                Text(data['correct-answer'] as String),
                Text(data['user-answer'] as String),
              ],
            ),
          ],
        );
      }).toList(),
    );
  }
}

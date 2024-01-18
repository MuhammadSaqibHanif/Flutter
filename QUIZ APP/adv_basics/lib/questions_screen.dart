import 'package:flutter/material.dart';

import 'package:adv_basics/answer_button.dart';

class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen({super.key});

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "data",
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 30),
          AnswerButton(onTap: () {}, answerText: "answerText 1"),
          AnswerButton(onTap: () {}, answerText: "answerText 2"),
          AnswerButton(onTap: () {}, answerText: "answerText 3"),
          AnswerButton(onTap: () {}, answerText: "answerText 4"),
        ],
      ),
    );
  }
}

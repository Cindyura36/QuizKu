import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../widgets/option_card.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kuis Berlangsung'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<QuizProvider>(
        builder: (context, quiz, child) {
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Soal ${quiz.currentQuestionIndex + 1} dari ${quiz.totalQuestions}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          'Skor: ${quiz.score}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    LinearProgressIndicator(
                      value: (quiz.currentQuestionIndex + 1) / quiz.totalQuestions,
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    const SizedBox(height: 32),

                    Text(
                      quiz.currentQuestion.questionText,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),

                    Expanded(
                      child: ListView.separated(
                        itemCount: quiz.currentQuestion.options.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          return OptionCard(
                            optionText: quiz.currentQuestion.options[index],
                            index: index,
                            isSelected: quiz.selectedOptionIndex == index,
                            isCorrect: index == quiz.currentQuestion.correctAnswerIndex,
                            isAnswered: quiz.isAnswered,
                            onTap: () => quiz.selectOption(index),
                          );
                        },
                      ),
                    ),

                    if (quiz.isAnswered)
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: quiz.isLastQuestion
                              ? () {
                            quiz.saveHistory();

                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (dialogContext) => AlertDialog(
                                title: const Text('Kuis Selesai! 🎉'),
                                content: Text('Skor akhir kamu adalah: ${quiz.score} / 100'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(dialogContext);
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Kembali ke Beranda'),
                                  ),
                                ],
                              ),
                            );
                          }
                              : quiz.nextQuestion,
                          child: Text(
                            quiz.isLastQuestion ? 'Lihat Skor' : 'Soal Selanjutnya',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
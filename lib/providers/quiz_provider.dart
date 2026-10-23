import 'package:flutter/material.dart';
import '../models/question_model.dart';
import '../models/history_model.dart';

class QuizProvider extends ChangeNotifier {
  int _currentQuestionIndex = 0;
  int _score = 0;
  int? _selectedOptionIndex;
  bool _isAnswered = false;
  List<Question> _questions = [];
  String _currentCategory = '';

  List<QuizHistory> _history = [];
  List<QuizHistory> get history => _history;

  int get currentQuestionIndex => _currentQuestionIndex;
  int get score => _score;
  int? get selectedOptionIndex => _selectedOptionIndex;
  bool get isAnswered => _isAnswered;
  Question get currentQuestion => _questions[_currentQuestionIndex];
  bool get isLastQuestion => _currentQuestionIndex == _questions.length - 1;
  int get totalQuestions => _questions.length;

  void startQuiz(List<Question> selectedQuestions, String category) {
    _questions = selectedQuestions;
    _currentCategory = category;
    _currentQuestionIndex = 0;
    _score = 0;
    _selectedOptionIndex = null;
    _isAnswered = false;
    notifyListeners();
  }

  void selectOption(int index) {
    if (_isAnswered) return;
    _selectedOptionIndex = index;
    _isAnswered = true;
    if (index == currentQuestion.correctAnswerIndex) {
      _score += 10;
    }
    notifyListeners();
  }

  void nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      _currentQuestionIndex++;
      _selectedOptionIndex = null;
      _isAnswered = false;
      notifyListeners();
    }
  }

  void saveHistory() {
    _history.add(
      QuizHistory(
        category: _currentCategory,
        score: _score,
        date: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
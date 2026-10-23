import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/quiz_provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final historyList = context.watch<QuizProvider>().history;

    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Kuis')),
      body: historyList.isEmpty
          ? const Center(
        child: Text('Belum ada riwayat kuis. Ayo mainkan kuisnya!'),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: historyList.length,
        itemBuilder: (context, index) {
          final item = historyList.reversed.toList()[index];

          final formattedDate = DateFormat('dd MMM yyyy, HH:mm').format(item.date);

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: const Icon(Icons.history, color: Colors.white),
              ),
              title: Text(item.category, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(formattedDate),
              trailing: Text(
                '${item.score}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: item.score >= 70 ? Colors.green : Colors.orange,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}